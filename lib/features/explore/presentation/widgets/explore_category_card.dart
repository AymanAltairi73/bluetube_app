import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/explore_category.dart';

/// Widget to display an explore category card
class ExploreCategoryCard extends StatelessWidget {
  final ExploreCategory category;
  final VoidCallback? onTap;

  const ExploreCategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the gradient colors
    final gradientStart = _parseColor(category.gradientStart);
    final gradientEnd = _parseColor(category.gradientEnd);

    // Parse the icon
    final IconData icon = _getIconData(category.icon);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        height: 80.h,
        margin: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientStart, gradientEnd],
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern (optional)
            Positioned(
              right: -20.w,
              bottom: -20.h,
              child: Icon(
                icon,
                size: 80.r,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 24.r,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    category.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to parse color from hex string
  Color _parseColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.blue; // Default color
    }
  }

  // Helper method to get icon data from string
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'music_note':
        return Icons.music_note;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'article':
        return Icons.article;
      case 'school':
        return Icons.school;
      case 'style':
        return Icons.style;
      case 'sports_basketball':
        return Icons.sports_basketball;
      case 'devices':
        return Icons.devices;
      default:
        return Icons.category;
    }
  }
}
