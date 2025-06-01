import 'package:flutter/material.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/report/report_bloc.dart';
import 'package:verbatica/BLOC/report/report_event.dart';
import 'package:verbatica/Utilities/DialogueBox.dart';
import 'package:verbatica/Utilities/theme_provider.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/settingviews/aboutus.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/settingviews/privacypolicy.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/settingviews/reportdata.dart'; // Import your reports screen
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/settingviews/savedpost.dart'; // Import your report bloc
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, 'GENERAL'),
                _buildSettingsSection(context, [
                  _buildSettingData(
                    title: 'Explore Saved posts',
                    icon: Icons.bookmark_outline,
                    iconColor: Theme.of(context).colorScheme.primary,
                    onTap: () => _navigateToScreen(context, 'saved_posts'),
                  ),

                  _buildSettingData(
                    title: 'Explore Report feedback',
                    icon: Icons.flag_outlined,
                    iconColor: Theme.of(context).colorScheme.secondary,
                    onTap: () => _navigateToScreen(context, 'report_feedback'),
                  ),
                ]),

                _buildSectionHeader(context, 'PREFERENCES'),
                _buildSettingsSection(context, [
                  _buildSettingData(
                    title: 'Reset content preferences',
                    icon: Icons.restart_alt_outlined,
                    iconColor: Theme.of(context).colorScheme.tertiary,
                    onTap: () => _showResetPreferencesDialog(context),
                  ),
                  _buildSettingData(
                    title: 'Reset password',
                    icon: Icons.lock_outline,
                    iconColor: Theme.of(context).colorScheme.secondary,
                    onTap: () => _navigateToScreen(context, 'reset_password'),
                  ),
                  _buildSettingData(
                    title: 'Dark mode',
                    icon: Icons.dark_mode_outlined,
                    iconColor: Theme.of(context).colorScheme.primary,
                    trailing: Switch(
                      value: Theme.of(context).brightness == Brightness.dark,
                      onChanged: (val) {
                        // Toggle theme would go here if implemented
                        _toggleTheme(context);
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ]),

                _buildSectionHeader(context, 'ACCOUNT'),
                _buildSettingsSection(context, [
                  _buildSettingData(
                    title: 'About us',
                    icon: Icons.info_outline,
                    iconColor: Theme.of(context).colorScheme.primary,
                    onTap: () => _navigateToScreen(context, 'about_us'),
                  ),
                  _buildSettingData(
                    title: 'Privacy Policy',
                    icon: Icons.privacy_tip_outlined,
                    iconColor: Theme.of(context).colorScheme.tertiary,
                    onTap: () => _navigateToScreen(context, 'privacy_policy'),
                  ),
                  _buildSettingData(
                    title: 'Logout',
                    icon: Icons.logout,
                    iconColor: Theme.of(context).colorScheme.error,
                    onTap: () => showLogoutDialog(context),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to navigate to appropriate screens
  void _navigateToScreen(BuildContext context, String screenName) {
    switch (screenName) {
      case 'saved_posts':
        // Navigate to saved posts screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: BlocProvider.of<UserBloc>(
                    context,
                  ), // 👈 reuse existing UserBloc
                  child: SavedPostsScreen(),
                ),
          ),
        );

        break;

      case 'report_feedback':
        // Navigate to report feedback screen using BLoC
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => BlocProvider(
                  create:
                      (context) =>
                          ReportBloc()..add(
                            FetchUserReports(
                              'user123', // Replace with actual user ID from your auth system
                            ),
                          ),
                  child: UserReportsScreen(),
                ),
          ),
        );
        break;

      case 'reset_password':
        // Navigate to reset password screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigate to Reset Password Screen')),
        );
        break;

      case 'about_us':
        // Navigate to about us screen
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => AboutUsScreen()));

        break;

      case 'privacy_policy':
        // Navigate to privacy policy screen
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));

        break;

      default:
        // Default case
        break;
    }
  }

  // Reset content preferences dialog
  void _showResetPreferencesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            title: Text(
              'Reset Content Preferences',
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            content: Text(
              'Are you sure you want to reset all your content preferences? This action cannot be undone.',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Implement reset preferences logic here
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Content preferences have been reset',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: Text('Reset'),
              ),
            ],
          ),
    );
  }

  void _toggleTheme(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    themeProvider.toggleTheme(!isDarkMode);
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 16, 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, List<SettingData> items) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              _buildSettingsItem(
                context,
                item.title,
                icon: item.icon,
                iconColor: item.iconColor,
                trailing: item.trailing,
                onTap: item.onTap,
              ),
              if (index < items.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 56, right: 16),
                  child: Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title, {
    IconData? icon,
    Color? iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final bool isLogout = title == 'Logout';

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? Theme.of(context).colorScheme.primary)
              .withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon ?? Icons.settings,
          color: iconColor ?? Theme.of(context).colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color:
              isLogout
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      trailing: Container(
        constraints: BoxConstraints(maxWidth: 100),
        child:
            trailing ??
            Icon(
              Icons.chevron_right,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
              size: 22,
            ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}

// Helper class to store setting data
class SettingData {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  SettingData({
    required this.title,
    required this.icon,
    required this.iconColor,
    this.trailing,
    this.onTap,
  });
}

// Helper method to create setting data
SettingData _buildSettingData({
  required String title,
  required IconData icon,
  required Color iconColor,
  Widget? trailing,
  VoidCallback? onTap,
}) {
  return SettingData(
    title: title,
    icon: icon,
    iconColor: iconColor,
    trailing: trailing,
    onTap: onTap,
  );
}
