import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/widgets/video_thumbnail.dart';
import '../../domain/entities/subscription_video.dart';

/// Widget to display a subscription video card
class SubscriptionVideoCard extends StatelessWidget {
  final SubscriptionVideo video;
  final VoidCallback? onTap;

  const SubscriptionVideoCard({
    super.key,
    required this.video,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // For shorts, use a different layout
    if (video.isShort) {
      return _buildShortCard(context);
    }

    // For regular videos
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          VideoThumbnail(
            thumbnailUrl: video.thumbnailUrl,
            duration: video.duration,
            isLive: video.isLive,
            height: 220.h,
            onTap: onTap,
          ),

          // Video info
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Channel avatar
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: AssetImage(video.channelAvatar),
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
                        '${video.channelName} • ${NumberFormatter.formatCompact(video.views)} views • ${DateFormatter.formatRelativeTime(video.publishedAt)}',
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

                // Options menu
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Show options menu
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortCard(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 160.w,
        height: 320.h, // Fixed height to prevent overflow
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Use minimum space needed
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Stack(
                children: [
                  Image.asset(
                    video.thumbnailUrl,
                    height: 240.h,
                    width: 160.w,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 8.w,
                    bottom: 8.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'SHORTS',
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
            ),
            SizedBox(height: 8.h),

            // Title - Wrap in Expanded to prevent overflow
            Expanded(
              child: Text(
                video.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 4.h),

            // Views
            Text(
              '${NumberFormatter.formatCompact(video.views)} views',
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
    );
  }
}
