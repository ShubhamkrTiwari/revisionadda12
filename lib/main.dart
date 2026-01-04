import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'utils/constants.dart';
import 'services/usage_tracker_service.dart';

void main() {
  runApp(const RevisionAddaApp());
}

class RevisionAddaApp extends StatefulWidget {
  const RevisionAddaApp({super.key});

  @override
  State<RevisionAddaApp> createState() => _RevisionAddaAppState();
}

class _RevisionAddaAppState extends State<RevisionAddaApp> {
  ThemeMode _themeMode = ThemeMode.system;
  final UsageTrackerService _usageTracker = UsageTrackerService();

  @override
  void initState() {
    super.initState();
    // Initialize usage tracker
    _usageTracker.initialize();
  }

  @override
  void dispose() {
    // Dispose usage tracker
    _usageTracker.dispose();
    super.dispose();
  }

  void changeThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: SplashScreen(
        onThemeModeChanged: changeThemeMode,
      ),
    );
  }
}
