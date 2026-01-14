import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart';
import '../services/subscription_service.dart';
import 'subscription_screen.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode)? onThemeModeChanged;
  
  const SettingsScreen({super.key, this.onThemeModeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isSubscribed = false;
  final int completedSets = 0;
  final int freeLimit = 5;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionStatus();
  }

  Future<void> _loadSubscriptionStatus() async {
    final subscribed = await SubscriptionService.isSubscribed();
    if (mounted) {
      setState(() {
        _isSubscribed = subscribed;
      });
    }
  }

  Future<void> _toggleDarkMode(bool value, ThemeProvider themeProvider) async {
    await themeProvider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    if (widget.onThemeModeChanged != null) {
      widget.onThemeModeChanged!(themeProvider.themeMode);
    }
  }

  Future<void> _toggleSystemTheme(bool value, ThemeProvider themeProvider) async {
    if (value) {
      await themeProvider.setThemeMode(ThemeMode.system);
    } else {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      await themeProvider.setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    }
    if (widget.onThemeModeChanged != null) {
      widget.onThemeModeChanged!(themeProvider.themeMode);
    }
  }

  Future<void> _shareApp() async {
    const appUrl = 'https://play.google.com/store/apps/details?id=com.example.revisionadda12';
    const message = 'Check out this amazing app - Revision Adda! $appUrl';
    
    await Share.share(
      message,
      subject: 'Revision Adda - Learn Better',
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trailing != null) trailing,
                ],
              ),
              if (showDivider && onTap != null)
                const Divider(height: 24, thickness: 1),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideX(
          begin: 0.1,
          end: 0,
          curve: Curves.easeOutQuart,
        );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 24, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
          const Expanded(
            child: Divider(
              height: 1,
              thickness: 1,
              indent: 12,
              endIndent: 0,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Upgrade to Pro',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colorScheme.onPrimary,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(
    BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return _buildSettingCard(
      context: context,
      icon: value ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
      title: title,
      subtitle: subtitle ?? (value ? 'Dark theme enabled' : 'Light theme enabled'),
      iconColor: value ? Colors.deepPurple : Colors.amber,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: colorScheme.primary,
      ),
      showDivider: false,
    );
  }

  Widget _buildFeatureItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withOpacity(0.1),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.person,
              size: 32,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'User',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (!_isSubscribed) _buildSubscribeButton(context),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final useSystemTheme = themeProvider.isSystemTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.primary,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final maxHeight = constraints.maxHeight;
                final minHeight = kToolbarHeight;
                final currentScroll = maxHeight - minHeight;
                final opacity = (currentScroll / (maxHeight - minHeight)).clamp(0.0, 1.0);
                
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Center(
                      child: Opacity(
                        opacity: 1 - (opacity * 0.9),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.settings,
                                size: 40,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Settings',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            title: Opacity(
              opacity: 0,
              child: Text(
                'Settings',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.info_outline, color: colorScheme.onPrimary),
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Revision Adda',
                    applicationVersion: '1.0.0',
                    applicationIcon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school, size: 32),
                    ),
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'A comprehensive study app for Class 12 students',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context),
                
                // Theme Settings
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: _buildSectionHeader(
                    'Appearance',
                    Icons.palette_rounded,
                    colorScheme.primary,
                  ),
                ),
                
                // System theme toggle
                _buildSettingCard(
                  context: context,
                  icon: Icons.phone_android_rounded,
                  title: 'Use system theme',
                  subtitle: 'Match your device\'s theme settings',
                  iconColor: Colors.blue,
                  trailing: Switch.adaptive(
                    value: useSystemTheme,
                    onChanged: (value) => _toggleSystemTheme(value, themeProvider),
                    activeColor: colorScheme.primary,
                  ),
                ),
                
                // Dark mode toggle (only show if not using system theme)
                if (!useSystemTheme)
                  _buildThemeToggle(
                    context,
                    title: 'Dark Mode',
                    value: isDark,
                    onChanged: (value) => _toggleDarkMode(value, themeProvider),
                  ),
                
                // App Settings Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: _buildSectionHeader(
                    'App Settings',
                    Icons.settings_rounded,
                    colorScheme.primary,
                  ),
                ),
                
                // Share App
                _buildSettingCard(
                  context: context,
                  icon: Icons.share_rounded,
                  title: 'Share App',
                  subtitle: 'Tell your friends about us',
                  iconColor: Colors.green,
                  onTap: _shareApp,
                ),
                
                // Rate App
                _buildSettingCard(
                  context: context,
                  icon: Icons.star_rate_rounded,
                  title: 'Rate Us',
                  subtitle: 'Leave a review on the app store',
                  iconColor: Colors.amber,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rate app functionality coming soon!')),
                    );
                  },
                ),
                
                // Contact Support
                _buildSettingCard(
                  context: context,
                  icon: Icons.support_agent_rounded,
                  title: 'Contact Support',
                  subtitle: 'Need help? Contact our support team',
                  iconColor: Colors.purple,
                  onTap: () async {
                    const email = 'support@revisionadda.com';
                    final url = 'mailto:$email';
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not launch email client')),
                        );
                      }
                    }
                  },
                ),
                
                // About Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: _buildSectionHeader(
                    'About',
                    Icons.info_rounded,
                    colorScheme.primary,
                  ),
                ),
                
                // Privacy Policy
                _buildSettingCard(
                  context: context,
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  iconColor: Colors.blueGrey,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy policy coming soon!')),
                    );
                  },
                ),
                
                // Terms of Service
                _buildSettingCard(
                  context: context,
                  icon: Icons.description_rounded,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                  iconColor: Colors.blueGrey,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Terms of service coming soon!')),
                    );
                  },
                  showDivider: false,
                ),
                
                // Version
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Center(
                    child: Text(
                      'Version 1.0.0',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
