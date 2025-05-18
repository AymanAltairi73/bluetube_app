import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/widgets/video_thumbnail.dart';
import '../../../../core/widgets/channel_avatar.dart';
import '../../domain/entities/video.dart';

/// Widget to display a video card in the home feed
class VideoCard extends StatelessWidget {
  final Video video;
  final VoidCallback? onTap;

  const VideoCard({
    super.key,
    required this.video,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                ChannelAvatar(
                  avatarUrl: video.channelAvatar,
                  radius: 20.r,
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
                  onPressed: () => _showOptionsMenu(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    Get.bottomSheet(
      Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Save to Watch Later'),
              onTap: () {
                Get.back();
                // Add to watch later
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Save to Playlist'),
              onTap: () {
                Get.back();
                // Add to playlist
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Get.back();
                // Share video
              },
            ),
            ListTile(
              leading: const Icon(Icons.not_interested),
              title: const Text('Not Interested'),
              onTap: () {
                Get.back();
                // Mark as not interested
              },
            ),
          ],
        ),
      ),
    );
  }
}
