import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsageTrackerService extends WidgetsBindingObserver {
  static final UsageTrackerService _instance = UsageTrackerService._internal();
  factory UsageTrackerService() => _instance;
  UsageTrackerService._internal();

  DateTime? _sessionStartTime;
  bool _isTracking = false;
  
  static const String _totalTimeKey = 'total_app_usage_time_seconds';
  static const String _todayTimeKey = 'today_app_usage_time_seconds';
  static const String _lastDateKey = 'last_tracking_date';

  /// Initialize the tracker
  void initialize() {
    WidgetsBinding.instance.addObserver(this);
    _startSession();
  }

  /// Dispose the tracker
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _endSession();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        _startSession();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _endSession();
        break;
      case AppLifecycleState.hidden:
        _endSession();
        break;
    }
  }

  void _startSession() {
    if (!_isTracking) {
      _sessionStartTime = DateTime.now();
      _isTracking = true;
    }
  }

  Future<void> _endSession() async {
    if (_isTracking && _sessionStartTime != null) {
      final sessionDuration = DateTime.now().difference(_sessionStartTime!);
      await _saveSessionTime(sessionDuration.inSeconds);
      _sessionStartTime = null;
      _isTracking = false;
    }
  }

  Future<void> _saveSessionTime(int seconds) async {
    if (seconds <= 0) return;
    
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Get last tracking date
    final lastDateString = prefs.getString(_lastDateKey);
    DateTime? lastDate;
    if (lastDateString != null) {
      lastDate = DateTime.parse(lastDateString);
    }
    
    // Reset today's time if it's a new day
    if (lastDate == null || lastDate.isBefore(today)) {
      await prefs.setInt(_todayTimeKey, 0);
      await prefs.setString(_lastDateKey, today.toIso8601String());
    }
    
    // Update total time
    final currentTotal = prefs.getInt(_totalTimeKey) ?? 0;
    await prefs.setInt(_totalTimeKey, currentTotal + seconds);
    
    // Update today's time
    final currentToday = prefs.getInt(_todayTimeKey) ?? 0;
    await prefs.setInt(_todayTimeKey, currentToday + seconds);
  }

  /// Get total time spent in the app (in seconds)
  Future<int> getTotalTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalTimeKey) ?? 0;
  }

  /// Get today's time spent in the app (in seconds)
  Future<int> getTodayTime() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final lastDateString = prefs.getString(_lastDateKey);
    if (lastDateString != null) {
      final lastDate = DateTime.parse(lastDateString);
      if (lastDate.isBefore(today)) {
        // It's a new day, reset today's time
        await prefs.setInt(_todayTimeKey, 0);
        await prefs.setString(_lastDateKey, today.toIso8601String());
        return 0;
      }
    }
    
    return prefs.getInt(_todayTimeKey) ?? 0;
  }

  /// Get current session time (if app is active)
  int getCurrentSessionTime() {
    if (_isTracking && _sessionStartTime != null) {
      return DateTime.now().difference(_sessionStartTime!).inSeconds;
    }
    return 0;
  }

  /// Format seconds to readable string (e.g., "2h 30m" or "45m")
  static String formatTime(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    }
    
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${hours}h';
    } else if (minutes > 0) {
      if (secs > 0) {
        return '${minutes}m ${secs}s';
      }
      return '${minutes}m';
    } else {
      return '${secs}s';
    }
  }
}

