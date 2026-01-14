import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'utils/constants.dart';
import 'services/usage_tracker_service.dart';
import 'services/notification_service.dart';
import 'utils/theme_provider.dart';

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
    // Initialize notification service
    NotificationService().initialize();
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..init()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
