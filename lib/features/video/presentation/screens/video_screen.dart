import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/di/dependency_injection.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/widgets/animated_button.dart';
import '../../../../core/widgets/animated_expandable.dart';
import '../../../../core/widgets/animated_list_item.dart';
import '../../domain/entities/video_detail.dart';
import '../controllers/video_controller.dart';
import '../widgets/custom_video_player.dart';
import '../widgets/comment_item.dart';
import '../widgets/related_video_item.dart';

/// Screen for playing videos
class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller from dependency injection
    final controller = Get.put(sl<VideoController>());

    return Obx(() {
      // Handle fullscreen mode
      if (controller.isFullScreen.value) {
        return _buildFullScreenPlayer(controller);
      }

      return Scaffold(
        body: SafeArea(
          child: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.errorMessage.value != null
                  ? _buildErrorView(controller.errorMessage.value!)
                  : controller.videoDetail.value != null
                      ? _buildVideoDetailView(controller)
                      : const SizedBox.shrink(),
        ),
      );
    });
  }

  Widget _buildFullScreenPlayer(VideoController controller) {
    // Set system UI overlay style for fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: CustomVideoPlayer(controller: controller),
          ),
          Positioned(
            top: 16.h,
            left: 16.w,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24.r,
              ),
              onPressed: () {
                controller.toggleFullScreen();
                // Reset system UI when exiting fullscreen
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.r, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            'Error',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoDetailView(VideoController controller) {
    final video = controller.videoDetail.value!;

    return Column(
      children: [
        // Video player
        CustomVideoPlayer(controller: controller),

        // Video details
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVideoHeader(video, controller),
                const Divider(),
                _buildChannelInfo(video, controller),
                _buildVideoDescription(video, controller),
                const Divider(),
                _buildCommentsSection(controller),
                const Divider(),
                _buildRelatedVideosSection(controller),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoHeader(VideoDetail video, VideoController controller) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            video.title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),

          // Views and date
          Text(
            '${NumberFormatter.formatCompact(video.views)} views • ${DateFormatter.formatRelativeTime(video.publishedAt)}',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16.h),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Like button
              _buildActionButton(
                icon: video.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                label: NumberFormatter.formatCompact(video.likes),
                isActive: video.isLiked,
                onTap: controller.likeCurrentVideo,
              ),

              // Dislike button
              _buildActionButton(
                icon: video.isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                label: NumberFormatter.formatCompact(video.dislikes),
                isActive: video.isDisliked,
                onTap: controller.dislikeCurrentVideo,
              ),

              // Share button
              _buildActionButton(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {
                  // Share video
                },
              ),

              // Download button
              _buildActionButton(
                icon: Icons.download_outlined,
                label: 'Download',
                onTap: () {
                  // Download video
                },
              ),

              // Save button
              _buildActionButton(
                icon: Icons.playlist_add_outlined,
                label: 'Save',
                onTap: () {
                  // Save video
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChannelInfo(VideoDetail video, VideoController controller) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          // Channel avatar
          CircleAvatar(
            radius: 24.r,
            backgroundImage: AssetImage(video.channelAvatar),
          ),
          SizedBox(width: 16.w),

          // Channel details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Channel name
                Text(
                  video.channelName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),

                // Subscriber count
                Text(
                  '${NumberFormatter.formatCompact(video.subscriberCount)} subscribers',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Subscribe button
          ElevatedButton(
            onPressed: controller.toggleSubscription,
            style: ElevatedButton.styleFrom(
              backgroundColor: video.isSubscribed ? Colors.grey[300] : Colors.red,
              foregroundColor: video.isSubscribed ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              video.isSubscribed ? 'Subscribed' : 'Subscribe',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoDescription(VideoDetail video, VideoController controller) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description text with animated expandable
              Obx(() {
                return AnimatedExpandable(
                  isExpanded: controller.isDescriptionExpanded.value,
                  onExpansionChanged: (value) => controller.toggleDescription(),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  header: Text(
                    video.description,
                    style: TextStyle(fontSize: 14.sp),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  content: Text(
                    video.description,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                );
              }),
              SizedBox(height: 8.h),

              // Show more/less button with animation
              AnimatedButton(
                scale: 0.95,
                onTap: controller.toggleDescription,
                child: Obx(() {
                  return Text(
                    controller.isDescriptionExpanded.value ? 'Show less' : 'Show more',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildCommentsSection(VideoController controller) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comments header
          _buildCommentsHeader(controller),
          SizedBox(height: 16.h),

          // Add comment
          _buildAddCommentRow(controller),

          // Comments list
          _buildCommentsList(controller),
        ],
      ),
    );
  }

  Widget _buildCommentsHeader(VideoController controller) {
    return GestureDetector(
      onTap: controller.toggleComments,
      child: Row(
        children: [
          Text(
            'Comments',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() {
            return controller.isCommentsLoading.value
                ? SizedBox(
                    width: 16.r,
                    height: 16.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    '${controller.comments.length}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  );
          }),
          const Spacer(),
          Obx(() {
            return Icon(
              controller.isCommentsVisible.value
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 24.r,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAddCommentRow(VideoController controller) {
    return Row(
      children: [
        // User avatar
        CircleAvatar(
          radius: 16.r,
          backgroundImage: const AssetImage('assets/images/profile.png'),
        ),
        SizedBox(width: 12.w),

        // Comment input
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              controller.commentText.value = value;
            },
          ),
        ),

        // Send button
        Obx(() {
          return controller.isAddingComment.value
              ? SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.send,
                    size: 24.r,
                    color: controller.commentText.value.isEmpty
                        ? Colors.grey[400]
                        : Colors.blue,
                  ),
                  onPressed: controller.commentText.value.isEmpty
                      ? null
                      : controller.addCommentToVideo,
                );
        }),
      ],
    );
  }

  Widget _buildCommentsList(VideoController controller) {
    return Obx(() {
      if (!controller.isCommentsVisible.value) {
        return const SizedBox.shrink();
      }

      if (controller.comments.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Center(
            child: Text(
              'No comments yet. Be the first to comment!',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.comments.length,
        itemBuilder: (context, index) {
          final comment = controller.comments[index];
          return AnimatedListItem(
            index: index,
            child: CommentItem(
              comment: comment,
              onLike: controller.likeCommentById,
              onReply: (_) {
                // Show reply input
              },
            ),
          );
        },
      );
    });
  }

  Widget _buildRelatedVideosSection(VideoController controller) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Related videos header
          Text(
            'Related Videos',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),

          // Related videos list
          _buildRelatedVideosList(controller),
        ],
      ),
    );
  }

  Widget _buildRelatedVideosList(VideoController controller) {
    return Obx(() {
      if (controller.isRelatedVideosLoading.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const CircularProgressIndicator(),
          ),
        );
      }

      if (controller.relatedVideos.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Text(
              'No related videos found',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.relatedVideos.length,
        itemBuilder: (context, index) {
          final video = controller.relatedVideos[index];
          return AnimatedListItem(
            index: index,
            beginOffset: const Offset(0.05, 0.0),
            child: RelatedVideoItem(
              video: video,
              onTap: () => controller.navigateToRelatedVideo(video.id),
            ),
          );
        },
      );
    });
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return AnimatedButton(
      onTap: onTap,
      scale: 0.9,
      duration: const Duration(milliseconds: 100),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24.r,
            color: isActive ? Colors.blue : null,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: isActive ? Colors.blue : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
