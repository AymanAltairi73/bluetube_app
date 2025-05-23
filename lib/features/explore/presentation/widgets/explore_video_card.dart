import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/explore_video.dart';

/// Widget to display an explore video card
class ExploreVideoCard extends StatelessWidget {
  final ExploreVideo video;
  final VoidCallback? onTap;
  final bool isHorizontal;

  const ExploreVideoCard({
    super.key,
    required this.video,
    this.onTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return isHorizontal ? _buildHorizontalCard() : _buildVerticalCard();
  }

  Widget _buildVerticalCard() {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 320.w,
        margin: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    video.thumbnailUrl,
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // Duration or Live indicator
                Positioned(
                  right: 8.w,
                  bottom: 8.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: video.isLive ? Colors.red : Colors.black.withAlpha(179),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      video.isLive ? 'LIVE' : video.duration,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Video info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Channel logo
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: AssetImage(video.channelLogo),
                ),
                SizedBox(width: 12.w),

                // Video details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        video.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),

                      // Channel name and video stats
                      Text(
                        '${video.channelName} • ${video.views} views • ${video.timeAgo}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCard() {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120.h,
        margin: EdgeInsets.all(8.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    video.thumbnailUrl,
                    height: 120.h,
                    width: 160.w,
                    fit: BoxFit.cover,
                  ),
                ),

                // Duration or Live indicator
                Positioned(
                  right: 8.w,
                  bottom: 8.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: video.isLive ? Colors.red : Colors.black.withAlpha(179),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      video.isLive ? 'LIVE' : video.duration,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),

            // Video details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    video.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),

                  // Channel name
                  Text(
                    video.channelName,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),

                  // Video stats
                  Text(
                    '${video.views} views • ${video.timeAgo}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
