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
      
      // Cancel old reminder if it existed
      if (oldNote != null && oldNote.isReminder && oldNote.reminderDate != null) {
        await _notificationService.cancelReminder(int.parse(oldNote.id));
      }
      
      // Schedule new reminder if set
      if (note.isReminder && note.reminderDate != null) {
        final now = DateTime.now();
        if (note.reminderDate!.isAfter(now)) {
          await _notificationService.scheduleReminder(
            id: int.parse(note.id),
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
      
      final prefs = await SharedPreferences.getInstance();
      final notesJson = json.encode(notes.map((n) => n.toJson()).toList());
      return await prefs.setString(_notesKey, notesJson);
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteNote(String noteId) async {
    try {
      final notes = await getNotes();
      final note = notes.firstWhere((n) => n.id == noteId);
      
      // Cancel reminder if exists
      if (note.isReminder && note.reminderDate != null) {
        await _notificationService.cancelReminder(int.parse(noteId));
      }
      
      notes.removeWhere((note) => note.id == noteId);
      
      final prefs = await SharedPreferences.getInstance();
      final notesJson = json.encode(notes.map((n) => n.toJson()).toList());
      return await prefs.setString(_notesKey, notesJson);
    } catch (e) {
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

