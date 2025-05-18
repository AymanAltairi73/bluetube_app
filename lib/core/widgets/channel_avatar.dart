import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

/// A reusable channel avatar widget
class ChannelAvatar extends StatelessWidget {
  final String avatarUrl;
  final double radius;
  final bool hasNewContent;
  final VoidCallback? onTap;

  const ChannelAvatar({
    super.key,
    required this.avatarUrl,
    this.radius = AppDimensions.channelAvatarRadius,
    this.hasNewContent = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage(avatarUrl),
          ),
          if (hasNewContent)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: radius * 0.3,
                height: radius * 0.3,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
