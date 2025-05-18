import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/video_detail.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/related_video.dart';
import '../../domain/usecases/get_video_detail.dart';
import '../../domain/usecases/get_video_comments.dart';
import '../../domain/usecases/get_related_videos.dart';
import '../../domain/usecases/like_video.dart';
import '../../domain/usecases/dislike_video.dart';
import '../../domain/usecases/remove_like_dislike.dart';
import '../../domain/usecases/subscribe_to_channel.dart';
import '../../domain/usecases/unsubscribe_from_channel.dart';
import '../../domain/usecases/add_comment.dart';
import '../../domain/usecases/like_comment.dart';
import '../../domain/usecases/unlike_comment.dart';

/// Controller for the Video screen using GetX
class VideoController extends GetxController {
  final GetVideoDetail getVideoDetail;
  final GetVideoComments getVideoComments;
  final GetRelatedVideos getRelatedVideos;
  final LikeVideo likeVideo;
  final DislikeVideo dislikeVideo;
  final RemoveLikeDislike removeLikeDislike;
  final SubscribeToChannel subscribeToChannel;
  final UnsubscribeFromChannel unsubscribeFromChannel;
  final AddComment addComment;
  final LikeComment likeComment;
  final UnlikeComment unlikeComment;

  VideoController({
    required this.getVideoDetail,
    required this.getVideoComments,
    required this.getRelatedVideos,
    required this.likeVideo,
    required this.dislikeVideo,
    required this.removeLikeDislike,
    required this.subscribeToChannel,
    required this.unsubscribeFromChannel,
    required this.addComment,
    required this.likeComment,
    required this.unlikeComment,
  });

  // State variables using Rx
  final RxBool isLoading = false.obs;
  final RxBool isCommentsLoading = false.obs;
  final RxBool isRelatedVideosLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final Rx<VideoDetail?> videoDetail = Rx<VideoDetail?>(null);
  final RxList<Comment> comments = <Comment>[].obs;
  final RxList<RelatedVideo> relatedVideos = <RelatedVideo>[].obs;
  final RxBool isDescriptionExpanded = false.obs;
  final RxBool isCommentsVisible = false.obs;
  final RxString commentText = ''.obs;
  final RxBool isAddingComment = false.obs;

  // Video player controller
  VideoPlayerController? videoPlayerController;
  final RxBool isVideoInitialized = false.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isFullScreen = false.obs;
  final RxDouble currentPosition = 0.0.obs;
  final RxDouble duration = 0.0.obs;
  final RxBool isBuffering = false.obs;
  final RxBool isControlsVisible = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get the video ID from the arguments
    final videoId = Get.arguments as String?;
    if (videoId != null) {
      loadVideoData(videoId);
    } else {
      errorMessage.value = 'Video ID not provided';
    }
  }

  @override
  void onClose() {
    disposeVideoPlayer();
    super.onClose();
  }

  /// Log error messages to the console
  void _logError(String message) {
    developer.log(message, name: 'VideoController');
  }

  /// Load video data (details, comments, related videos)
  Future<void> loadVideoData(String videoId) async {
    isLoading.value = true;
    errorMessage.value = null;

    // Load video details
    final detailResult = await getVideoDetail(videoId);

    detailResult.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (detail) {
        videoDetail.value = detail;
        isLoading.value = false;

        // Initialize video player
        initializeVideoPlayer(detail.videoUrl);

        // Load comments and related videos
        loadComments(videoId);
        loadRelatedVideos(videoId);
      },
    );
  }

  /// Load comments for the video
  Future<void> loadComments(String videoId) async {
    isCommentsLoading.value = true;

    final commentsResult = await getVideoComments(videoId);

    commentsResult.fold(
      (failure) {
        // Don't set the main error message, just log it
        _logError('Failed to load comments: ${failure.message}');
        isCommentsLoading.value = false;
      },
      (commentsList) {
        comments.assignAll(commentsList);
        isCommentsLoading.value = false;
      },
    );
  }

  /// Load related videos for the video
  Future<void> loadRelatedVideos(String videoId) async {
    isRelatedVideosLoading.value = true;

    final relatedResult = await getRelatedVideos(videoId);

    relatedResult.fold(
      (failure) {
        // Don't set the main error message, just log it
        _logError('Failed to load related videos: ${failure.message}');
        isRelatedVideosLoading.value = false;
      },
      (videosList) {
        relatedVideos.assignAll(videosList);
        isRelatedVideosLoading.value = false;
      },
    );
  }

  /// Initialize the video player
  void initializeVideoPlayer(String videoUrl) {
    disposeVideoPlayer();

    // Create a new controller
    videoPlayerController = VideoPlayerController.asset(videoUrl)
      ..initialize().then((_) {
        isVideoInitialized.value = true;
        duration.value = videoPlayerController!.value.duration.inMilliseconds.toDouble();

        // Start playing the video
        videoPlayerController!.play();
        isPlaying.value = true;

        // Add listener for position updates
        videoPlayerController!.addListener(_videoPlayerListener);
      });
  }

  /// Dispose the video player
  void disposeVideoPlayer() {
    if (videoPlayerController != null) {
      videoPlayerController!.removeListener(_videoPlayerListener);
      videoPlayerController!.dispose();
      videoPlayerController = null;
      isVideoInitialized.value = false;
      isPlaying.value = false;
    }
  }

  /// Video player listener for position updates
  void _videoPlayerListener() {
    if (videoPlayerController != null) {
      currentPosition.value = videoPlayerController!.value.position.inMilliseconds.toDouble();
      isBuffering.value = videoPlayerController!.value.isBuffering;
      isPlaying.value = videoPlayerController!.value.isPlaying;
    }
  }

  /// Play or pause the video
  void togglePlayPause() {
    if (videoPlayerController != null) {
      if (isPlaying.value) {
        videoPlayerController!.pause();
      } else {
        videoPlayerController!.play();
      }
      isPlaying.value = !isPlaying.value;
    }
  }

  /// Seek to a specific position in the video
  void seekTo(Duration position) {
    if (videoPlayerController != null) {
      videoPlayerController!.seekTo(position);
    }
  }

  /// Toggle fullscreen mode
  void toggleFullScreen() {
    isFullScreen.value = !isFullScreen.value;
  }

  /// Toggle video controls visibility
  void toggleControls() {
    isControlsVisible.value = !isControlsVisible.value;

    // Auto-hide controls after 3 seconds
    if (isControlsVisible.value) {
      Future.delayed(const Duration(seconds: 3), () {
        if (isControlsVisible.value) {
          isControlsVisible.value = false;
        }
      });
    }
  }

  /// Format duration for display
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  /// Toggle description expansion
  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  /// Toggle comments visibility
  void toggleComments() {
    isCommentsVisible.value = !isCommentsVisible.value;
  }

  /// Like the current video
  Future<void> likeCurrentVideo() async {
    if (videoDetail.value == null) return;

    final videoId = videoDetail.value!.id;

    if (videoDetail.value!.isLiked) {
      // If already liked, remove the like
      final result = await removeLikeDislike(videoId);

      result.fold(
        (failure) {
          // Show a snackbar with the error
          Get.snackbar('Error', failure.message);
        },
        (success) {
          // Update the video detail
          videoDetail.value = videoDetail.value!.copyWith(isLiked: false);
        },
      );
    } else {
      // Like the video
      final result = await likeVideo(videoId);

      result.fold(
        (failure) {
          // Show a snackbar with the error
          Get.snackbar('Error', failure.message);
        },
        (success) {
          // Update the video detail
          videoDetail.value = videoDetail.value!.copyWith(
            isLiked: true,
            isDisliked: false,
          );
        },
      );
    }
  }

  /// Dislike the current video
  Future<void> dislikeCurrentVideo() async {
    if (videoDetail.value == null) return;

    final videoId = videoDetail.value!.id;

    if (videoDetail.value!.isDisliked) {
      // If already disliked, remove the dislike
      final result = await removeLikeDislike(videoId);

      result.fold(
        (failure) {
          // Show a snackbar with the error
          Get.snackbar('Error', failure.message);
        },
        (success) {
          // Update the video detail
          videoDetail.value = videoDetail.value!.copyWith(isDisliked: false);
        },
      );
    } else {
      // Dislike the video
      final result = await dislikeVideo(videoId);

      result.fold(
        (failure) {
          // Show a snackbar with the error
          Get.snackbar('Error', failure.message);
        },
        (success) {
          // Update the video detail
          videoDetail.value = videoDetail.value!.copyWith(
            isDisliked: true,
            isLiked: false,
          );
        },
      );
    }
  }

  /// Subscribe or unsubscribe from the channel
  Future<void> toggleSubscription() async {
    if (videoDetail.value == null) return;

    final channelId = videoDetail.value!.channelId;

    if (videoDetail.value!.isSubscribed) {
      // Unsubscribe from the channel
      final result = await unsubscribeFromChannel(channelId);

      result.fold(
        (failure) {
          // Show a snackbar with the error
          Get.snackbar('Error', failure.message);
        },
        (success) {
          // Update the video detail
          videoDetail.value = videoDetail.value!.copyWith(isSubscribed: false);
        },
      );
    } else {
      // Subscribe to the channel
      final result = await subscribeToChannel(channelId);

      result.fold(
        (failure) {
          // Show a snackbar with the error
          Get.snackbar('Error', failure.message);
        },
        (success) {
          // Update the video detail
          videoDetail.value = videoDetail.value!.copyWith(isSubscribed: true);
        },
      );
    }
  }

  /// Add a comment to the video
  Future<void> addCommentToVideo() async {
    if (videoDetail.value == null || commentText.value.isEmpty) return;

    isAddingComment.value = true;

    final videoId = videoDetail.value!.id;
    final result = await addComment(videoId, commentText.value);

    result.fold(
      (failure) {
        // Show a snackbar with the error
        Get.snackbar('Error', failure.message);
        isAddingComment.value = false;
      },
      (comment) {
        // Add the comment to the list
        comments.insert(0, comment);
        commentText.value = '';
        isAddingComment.value = false;
      },
    );
  }

  /// Like a comment
  Future<void> likeCommentById(String commentId) async {
    final commentIndex = comments.indexWhere((comment) => comment.id == commentId);
    if (commentIndex == -1) return;

    final comment = comments[commentIndex];

    if (comment.isLiked) {
      // Unlike the comment
      final result = await unlikeComment(commentId);

      result.fold(
        (failure) {
          // Show a snackbar with the error
          Get.snackbar('Error', failure.message);
        },
        (success) {
          // Update the comment
          final updatedComment = Comment(
            id: comment.id,
            videoId: comment.videoId,
            userId: comment.userId,
            userName: comment.userName,
            userAvatar: comment.userAvatar,
            text: comment.text,
            createdAt: comment.createdAt,
            likes: comment.likes - 1,
            replies: comment.replies,
            isLiked: false,
            isPinned: comment.isPinned,
            isOwner: comment.isOwner,
          );

          comments[commentIndex] = updatedComment;
        },
      );
    } else {
      // Like the comment
      final result = await likeComment(commentId);

      result.fold(
        (failure) {
          // Show a snackbar with the error
          Get.snackbar('Error', failure.message);
        },
        (success) {
          // Update the comment
          final updatedComment = Comment(
            id: comment.id,
            videoId: comment.videoId,
            userId: comment.userId,
            userName: comment.userName,
            userAvatar: comment.userAvatar,
            text: comment.text,
            createdAt: comment.createdAt,
            likes: comment.likes + 1,
            replies: comment.replies,
            isLiked: true,
            isPinned: comment.isPinned,
            isOwner: comment.isOwner,
          );

          comments[commentIndex] = updatedComment;
        },
      );
    }
  }

  /// Navigate to a related video
  void navigateToRelatedVideo(String videoId) {
    // Pause the current video
    if (videoPlayerController != null) {
      videoPlayerController!.pause();
    }

    // Navigate to the video screen with the new video ID
    Get.offAndToNamed('/video', arguments: videoId);
  }
}

/// Extension to add copyWith method to VideoDetail
extension VideoDetailExtension on VideoDetail {
  VideoDetail copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    String? channelId,
    String? channelName,
    String? channelAvatar,
    int? views,
    int? likes,
    int? dislikes,
    DateTime? publishedAt,
    bool? isLiked,
    bool? isDisliked,
    bool? isSubscribed,
    int? subscriberCount,
    List<String>? tags,
    String? category,
    bool? isLive,
  }) {
    return VideoDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      channelAvatar: channelAvatar ?? this.channelAvatar,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      publishedAt: publishedAt ?? this.publishedAt,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscriberCount: subscriberCount ?? this.subscriberCount,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      isLive: isLive ?? this.isLive,
    );
  }
}
