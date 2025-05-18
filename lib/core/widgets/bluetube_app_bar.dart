import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/app_dimensions.dart';

/// A custom app bar for the BlueTube app
class BlueTubeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLogo;
  final VoidCallback? onLogoTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCastTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final String? profileImageUrl;
  final int notificationCount;

  const BlueTubeAppBar({
    super.key,
    this.title = '',
    this.actions,
    this.showLogo = true,
    this.onLogoTap,
    this.onSearchTap,
    this.onNotificationTap,
    this.onCastTap,
    this.onProfileTap,
    this.onSettingsTap,
    this.profileImageUrl,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: showLogo
          ? GestureDetector(
              onTap: onLogoTap,
              child: Image.asset(
                AppConstants.logoPath,
                height: 24,
              ),
            )
          : Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
      actions: actions ??
          [
            IconButton(
              icon: const Icon(Icons.cast, color: Colors.black),
              onPressed: onCastTap,
            ),
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined, color: Colors.black),
                  if (notificationCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          notificationCount > 9 ? '9+' : notificationCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: onNotificationTap,
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: onSearchTap,
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: onSettingsTap,
            ),
            if (profileImageUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
                child: GestureDetector(
                  onTap: onProfileTap,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage(profileImageUrl!),
                  ),
                ),
              ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
