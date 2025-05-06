import 'package:flutter/material.dart';
import 'package:verbatica/Utilities/DialogueBox.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'GENERAL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),

            _buildSettingsItem(context, 'Explore Saved posts'),
            _buildSettingsItem(context, 'Explore Report feedback'),
            Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'PREFERENCES',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            _buildSettingsItem(context, 'Reset content preferences'),
            _buildSettingsItem(context, 'Reset password'),
            _buildSettingsItem(context, 'Dark mode'),
            Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'ACCOUNT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),

            _buildSettingsItem(context, 'About us'),
            _buildSettingsItem(context, 'Privacy Policy'),
            _buildSettingsItem(context, 'Logout'),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title, {
    Widget? trailing,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Container(
        constraints: BoxConstraints(maxWidth: 100),
        child: trailing ?? Icon(Icons.chevron_right, color: Colors.grey),
      ),
      onTap: () {
        switch (title) {
          case 'Logout':
            showLogoutDialog(context);
            break;
          case 'Reset password':
            // Implement reset password logic
            break;
          case 'About us':
            // Navigate to about us screen
            break;
        }
      },
    );
  }
}
