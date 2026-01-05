import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NotesService {
  static const String _notesKey = 'user_notes';
  static NotesService? _instance;
  static NotesService get instance => _instance ??= NotesService._();
  
  NotesService._();

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
      if (existingIndex != -1) {
        notes[existingIndex] = note;
      } else {
        notes.add(note);
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

