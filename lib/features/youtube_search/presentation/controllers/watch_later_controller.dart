import 'package:get/get.dart';
import '../../domain/entities/saved_video.dart';
import '../../domain/entities/youtube_video.dart';
import '../../domain/usecases/get_saved_videos.dart';
import '../../domain/usecases/save_video.dart';
import '../../domain/usecases/remove_saved_video.dart';
import '../../domain/usecases/is_video_saved.dart';

/// Controller for Watch Later functionality
class WatchLaterController extends GetxController {
  final GetSavedVideos getSavedVideos;
  final SaveVideo saveVideo;
  final RemoveSavedVideo removeSavedVideo;
  final IsVideoSaved isVideoSaved;

  /// Constructor
  WatchLaterController({
    required this.getSavedVideos,
    required this.saveVideo,
    required this.removeSavedVideo,
    required this.isVideoSaved,
  });

  // Observable variables
  final RxList<SavedVideo> videos = <SavedVideo>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxMap<String, bool> savedStatus = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedVideos();
  }

  /// Load saved videos
  Future<void> loadSavedVideos() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getSavedVideos();

    isLoading.value = false;

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (videosList) {
        videos.value = videosList;
        // Update saved status map
        for (final video in videosList) {
          savedStatus[video.id] = true;
        }
      },
    );
  }

  /// Save a video to Watch Later
  Future<bool> saveVideoToWatchLater(YouTubeVideo video) async {
    final savedVideo = SavedVideo.fromYouTubeVideo(
      id: video.id,
      title: video.title,
      thumbnailUrl: video.thumbnailHighUrl,
      channelTitle: video.channelTitle,
      duration: video.duration,
    );

    final result = await saveVideo(savedVideo);

    return result.fold(
      (failure) {
        errorMessage.value = failure.message;
        return false;
      },
      (success) {
        if (success) {
          // Update local state
          videos.add(savedVideo);
          savedStatus[video.id] = true;
          
          Get.snackbar(
            'Success',
            'Video added to Watch Later',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        return success;
      },
    );
  }

  /// Remove a video from Watch Later
  Future<bool> removeVideoFromWatchLater(String videoId) async {
    final result = await removeSavedVideo(videoId);

    return result.fold(
      (failure) {
        errorMessage.value = failure.message;
        return false;
      },
      (success) {
        if (success) {
          // Update local state
          videos.removeWhere((v) => v.id == videoId);
          savedStatus[videoId] = false;
          
          Get.snackbar(
            'Success',
            'Video removed from Watch Later',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        return success;
      },
    );
  }

  /// Check if a video is saved
  Future<bool> checkIfVideoIsSaved(String videoId) async {
    // Check local cache first
    if (savedStatus.containsKey(videoId)) {
      return savedStatus[videoId]!;
    }

    final result = await isVideoSaved(videoId);

    return result.fold(
      (failure) {
        errorMessage.value = failure.message;
        return false;
      },
      (isSaved) {
        // Update local cache
        savedStatus[videoId] = isSaved;
        return isSaved;
      },
    );
  }

  /// Toggle save status
  Future<bool> toggleSaveStatus(YouTubeVideo video) async {
    final isSaved = await checkIfVideoIsSaved(video.id);

    if (isSaved) {
      return await removeVideoFromWatchLater(video.id);
    } else {
      return await saveVideoToWatchLater(video);
    }
  }
}
