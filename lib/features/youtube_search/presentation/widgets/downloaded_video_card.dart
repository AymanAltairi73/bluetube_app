import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/downloaded_video.dart';

/// Widget to display a downloaded video card
class DownloadedVideoCard extends StatelessWidget {
  final DownloadedVideo video;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const DownloadedVideoCard({
    super.key,
    required this.video,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('downloaded_video_${video.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30.r,
        ),
      ),
      onDismissed: (direction) {
        if (onDelete != null) {
          onDelete!();
        }
      },
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail with duration
              _buildThumbnail(),
              SizedBox(width: 12.w),

              // Video info
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

                    // Channel name
                    Text(
                      video.channelTitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),

                    // File info
                    Row(
                      children: [
                        Icon(
                          Icons.hd,
                          size: 16.r,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          video.quality,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.storage,
                          size: 16.r,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          video.formattedFileSize,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Delete button
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
                tooltip: 'Delete Download',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Stack(
      children: [
        // Thumbnail image
        SizedBox(
          width: 120.w,
          height: 68.h,
          child: _buildThumbnailImage(),
        ),

        // Duration indicator
        if (video.duration != null)
          Positioned(
            right: 4.w,
            bottom: 4.h,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(179), // 0.7 opacity
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Text(
                video.formattedDuration,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

        // Offline indicator
        Positioned(
          left: 4.w,
          top: 4.h,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.offline_pin,
                  size: 10.r,
                  color: Colors.white,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Offline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailImage() {
    // Check if the thumbnail is a local file or a network URL
    if (video.thumbnailUrl.startsWith('http')) {
      return Image.network(
        video.thumbnailUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.error,
              color: Colors.red,
              size: 32.r,
            ),
          );
        },
      );
    } else {
      // Local file
      final file = File(video.thumbnailUrl);
      return FutureBuilder<bool>(
        future: file.exists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasData && snapshot.data == true) {
            return Image.file(
              file,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 32.r,
                  ),
                );
              },
            );
          } else {
            return Container(
              color: Colors.grey[300],
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey[600],
                size: 32.r,
              ),
            );
          }
        },
      );
    }
  }
}
