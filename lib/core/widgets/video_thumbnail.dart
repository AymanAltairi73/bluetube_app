import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

/// A reusable video thumbnail widget
class VideoThumbnail extends StatelessWidget {
  final String thumbnailUrl;
  final String? duration;
  final bool isLive;
  final bool isShort;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const VideoThumbnail({
    super.key,
    required this.thumbnailUrl,
    this.duration,
    this.isLive = false,
    this.isShort = false,
    this.height,
    this.width,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Thumbnail image
          ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.borderRadiusSm),
            child: Image.asset(
              thumbnailUrl,
              width: width ?? double.infinity,
              height: height ?? AppDimensions.videoThumbnailHeight,
              fit: BoxFit.cover,
            ),
          ),

          // Duration indicator
          if (duration != null && !isLive)
            Positioned(
              right: AppDimensions.sm,
              bottom: AppDimensions.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.xs,
                  vertical: AppDimensions.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXs),
                ),
                child: Text(
                  duration!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppDimensions.fontSizeXs,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // Live indicator
          if (isLive)
            Positioned(
              right: AppDimensions.sm,
              bottom: AppDimensions.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm,
                  vertical: AppDimensions.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXs),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimensions.fontSizeXs,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Shorts indicator
          if (isShort)
            Positioned(
              left: AppDimensions.sm,
              bottom: AppDimensions.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm,
                  vertical: AppDimensions.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXs),
                ),
                child: const Text(
                  'SHORTS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimensions.fontSizeXs,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
