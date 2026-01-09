import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import 'notification_service.dart';

class NotesService {
  static const String _notesKey = 'user_notes';
  static NotesService? _instance;
  static NotesService get instance => _instance ??= NotesService._();
  final NotificationService _notificationService = NotificationService();
  
  NotesService._() {
    _notificationService.initialize();
  }

  Future<List<Note>> getNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = prefs.getString(_notesKey);
      
      if (notesJson == null) {
        return [];
      }
      
      final List<dynamic> notesList = json.decode(notesJson);
      return notesList.map((json) => Note.fromJson(json as Map<String, dynamic>)).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by newest first
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveNote(Note note) async {
    try {
      final notes = await getNotes();
      
      // Check if note with same ID exists, update it; otherwise add new
      final existingIndex = notes.indexWhere((n) => n.id == note.id);
      Note? oldNote;
      if (existingIndex != -1) {
        oldNote = notes[existingIndex];
        notes[existingIndex] = note;
      } else {
        notes.add(note);
      }
      
      // Cancel old reminder if it existed (don't let this fail the save)
      if (oldNote != null && oldNote.isReminder && oldNote.reminderDate != null) {
        try {
          final oldId = int.tryParse(oldNote.id);
          if (oldId != null) {
            await _notificationService.cancelReminder(oldId);
          }
        } catch (e) {
          // Ignore notification cancellation errors
          print('Error canceling old reminder: $e');
        }
      }
      
      // Schedule new reminder if set (don't let this fail the save)
      if (note.isReminder && note.reminderDate != null) {
        try {
          final now = DateTime.now();
          if (note.reminderDate!.isAfter(now)) {
            final noteId = int.tryParse(note.id);
            if (noteId != null) {
              await _notificationService.scheduleReminder(
                id: noteId,
                title: note.title,
                body: note.content.isNotEmpty 
                    ? note.content.length > 100 
                        ? '${note.content.substring(0, 100)}...' 
                        : note.content
                    : 'Reminder: ${note.title}',
                scheduledDate: note.reminderDate!,
                payload: note.id,
              );
            }
          }
        } catch (e) {
          // Ignore notification scheduling errors, but log them
          print('Error scheduling reminder: $e');
        }
      }
      
      // Save the note to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final notesJson = json.encode(notes.map((n) => n.toJson()).toList());
      final saved = await prefs.setString(_notesKey, notesJson);
      
      if (!saved) {
        print('Failed to save note to SharedPreferences');
        return false;
      }
      
      return true;
    } catch (e) {
      print('Error saving note: $e');
      return false;
    }
  }

  Future<bool> deleteNote(String noteId) async {
    try {
      final notes = await getNotes();
      final noteIndex = notes.indexWhere((n) => n.id == noteId);
      
      if (noteIndex == -1) {
        print('Note not found: $noteId');
        return false;
      }
      
      final note = notes[noteIndex];
      
      // Cancel reminder if exists (don't let this fail the delete)
      if (note.isReminder && note.reminderDate != null) {
        try {
          final id = int.tryParse(noteId);
          if (id != null) {
            await _notificationService.cancelReminder(id);
          }
        } catch (e) {
          // Ignore notification cancellation errors
          print('Error canceling reminder: $e');
        }
      }
      
      notes.removeAt(noteIndex);
      
      final prefs = await SharedPreferences.getInstance();
      final notesJson = json.encode(notes.map((n) => n.toJson()).toList());
      final deleted = await prefs.setString(_notesKey, notesJson);
      
      if (!deleted) {
        print('Failed to delete note from SharedPreferences');
        return false;
      }
      
      return true;
    } catch (e) {
      print('Error deleting note: $e');
      return false;
    }
  }

  Future<List<Note>> getReminders() async {
    final notes = await getNotes();
    final now = DateTime.now();
    return notes.where((note) => 
      note.isReminder && 
      note.reminderDate != null && 
      note.reminderDate!.isAfter(now)
    ).toList()
      ..sort((a, b) => a.reminderDate!.compareTo(b.reminderDate!));
  }
}

