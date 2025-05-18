import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme_controller.dart';

/// Settings screen for the app
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        children: [
          // Theme settings
          _buildSectionHeader('Appearance'),

          // Dark mode toggle
          GetBuilder<ThemeController>(
            builder: (controller) => SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Toggle between light and dark theme'),
              value: controller.isDarkMode,
              onChanged: (value) => controller.toggleTheme(),
              secondary: Icon(
                controller.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                size: 28.r,
              ),
            ),
          ),

          const Divider(),

          // Account settings
          _buildSectionHeader('Account'),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            subtitle: const Text('Manage your profile information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to profile screen
            },
          ),

          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Configure notification preferences'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to notifications screen
            },
          ),

          const Divider(),

          // Video settings
          _buildSectionHeader('Video Playback'),

          ListTile(
            leading: const Icon(Icons.hd),
            title: const Text('Video Quality'),
            subtitle: const Text('Set default video quality'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to video quality settings
            },
          ),

          ListTile(
            leading: const Icon(Icons.data_usage),
            title: const Text('Data Saver'),
            subtitle: const Text('Reduce data usage when streaming'),
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // Toggle data saver
              },
            ),
            onTap: () {
              // Toggle data saver
            },
          ),

          const Divider(),

          // About section
          _buildSectionHeader('About'),

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show terms of service
            },
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show privacy policy
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 16.h, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Get.theme.colorScheme.primary,
        ),
      ),
    );
  }
}
