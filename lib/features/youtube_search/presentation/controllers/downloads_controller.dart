import 'dart:async';
import 'package:get/get.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/downloaded_video.dart';
import '../../domain/entities/youtube_video.dart';
import '../../domain/usecases/get_downloaded_videos.dart';
import '../../domain/usecases/download_video.dart';
import '../../domain/usecases/delete_downloaded_video.dart';
import '../../domain/usecases/is_video_downloaded.dart';

/// Controller for downloads functionality
class DownloadsController extends GetxController {
  final GetDownloadedVideos getDownloadedVideos;
  final DownloadVideo downloadVideo;
  final DeleteDownloadedVideo deleteDownloadedVideo;
  final IsVideoDownloaded isVideoDownloaded;

  /// Constructor
  DownloadsController({
    required this.getDownloadedVideos,
    required this.downloadVideo,
    required this.deleteDownloadedVideo,
    required this.isVideoDownloaded,
  });

  // Observable variables
  final RxList<DownloadedVideo> videos = <DownloadedVideo>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxMap<String, bool> downloadedStatus = <String, bool>{}.obs;
  final RxInt totalSize = 0.obs;
  final RxDouble downloadProgress = 0.0.obs;
  final RxBool isDownloading = false.obs;
  final RxString currentDownloadId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDownloadedVideos();
  }

  /// Load downloaded videos
  Future<void> loadDownloadedVideos() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getDownloadedVideos(const NoParams());

    isLoading.value = false;

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (videosList) {
        videos.value = videosList;
        // Update downloaded status map
        for (final video in videosList) {
          downloadedStatus[video.id] = true;
        }
        // Calculate total size
        totalSize.value = videosList.fold(0, (sum, video) => sum + video.fileSize);
      },
    );
  }

  /// Download a video
  Future<bool> downloadYouTubeVideo(YouTubeVideo video, {String quality = '720p'}) async {
    // Check if already downloading
    if (isDownloading.value) {
      Get.snackbar(
        'Download in Progress',
        'Please wait for the current download to complete',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Start download
    isDownloading.value = true;
    currentDownloadId.value = video.id;
    downloadProgress.value = 0.0;

    // Simulate download progress
    _simulateDownloadProgress();

    final result = await downloadVideo(DownloadVideoParams(video: video, quality: quality));

    return result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isDownloading.value = false;
        currentDownloadId.value = '';
        downloadProgress.value = 0.0;

        Get.snackbar(
          'Download Failed',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );

        return false;
      },
      (downloadedVideo) {
        // Update local state
        videos.add(downloadedVideo);
        downloadedStatus[video.id] = true;
        totalSize.value += downloadedVideo.fileSize;

        isDownloading.value = false;
        currentDownloadId.value = '';
        downloadProgress.value = 1.0;

        Get.snackbar(
          'Download Complete',
          '${video.title} has been downloaded',
          snackPosition: SnackPosition.BOTTOM,
        );

        return true;
      },
    );
  }

  /// Delete a downloaded video
  Future<bool> deleteVideo(String videoId) async {
    final result = await deleteDownloadedVideo(DeleteDownloadedVideoParams(videoId: videoId));

    return result.fold(
      (failure) {
        errorMessage.value = failure.message;

        Get.snackbar(
          'Delete Failed',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );

        return false;
      },
      (success) {
        if (success) {
          // Update local state
          final deletedVideo = videos.firstWhere((v) => v.id == videoId);
          videos.removeWhere((v) => v.id == videoId);
          downloadedStatus[videoId] = false;
          totalSize.value -= deletedVideo.fileSize;

          Get.snackbar(
            'Video Deleted',
            'The video has been removed from downloads',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        return success;
      },
    );
  }

  /// Check if a video is downloaded
  Future<bool> checkIfVideoIsDownloaded(String videoId) async {
    // Check local cache first
    if (downloadedStatus.containsKey(videoId)) {
      return downloadedStatus[videoId]!;
    }

    final result = await isVideoDownloaded(IsVideoDownloadedParams(videoId: videoId));

    return result.fold(
      (failure) {
        errorMessage.value = failure.message;
        return false;
      },
      (isDownloaded) {
        // Update local cache
        downloadedStatus[videoId] = isDownloaded;
        return isDownloaded;
      },
    );
  }

  /// Toggle download status
  Future<bool> toggleDownloadStatus(YouTubeVideo video) async {
    final isDownloaded = await checkIfVideoIsDownloaded(video.id);

    if (isDownloaded) {
      return await deleteVideo(video.id);
    } else {
      return await downloadYouTubeVideo(video);
    }
  }

  /// Simulate download progress
  void _simulateDownloadProgress() {
    // Reset progress
    downloadProgress.value = 0.0;

    // Cancel any existing timer
    _cancelProgressTimer();

    const totalSteps = 20;
    int currentStep = 0;

    // Create a periodic timer for smoother progress updates
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // Calculate progress with a slight randomization for realism
      currentStep++;

      // Use a non-linear progress curve for more realistic download simulation
      // This makes it start faster and slow down towards the end
      final progress = _calculateNonLinearProgress(currentStep / totalSteps);
      downloadProgress.value = progress;

      // Stop at 90% - the final jump to 100% happens when download actually completes
      if (currentStep >= totalSteps || progress >= 0.9) {
        timer.cancel();
        _progressTimer = null;
        downloadProgress.value = 0.9; // Cap at 90%
      }
    });
  }

  /// Calculate non-linear progress for more realistic download simulation
  double _calculateNonLinearProgress(double linearProgress) {
    // This formula makes progress faster at the beginning and slower at the end
    // It's a simple ease-out function
    return 1 - (1 - linearProgress) * (1 - linearProgress);
  }

  /// Cancel any existing progress timer
  void _cancelProgressTimer() {
    if (_progressTimer != null && _progressTimer!.isActive) {
      _progressTimer!.cancel();
      _progressTimer = null;
    }
  }

  // Timer for progress simulation
  Timer? _progressTimer;

  @override
  void onClose() {
    _cancelProgressTimer();
    super.onClose();
  }

  /// Get formatted total size
  String get formattedTotalSize {
    if (totalSize.value < 1024) {
      return '${totalSize.value} B';
    } else if (totalSize.value < 1024 * 1024) {
      final kb = totalSize.value / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    } else if (totalSize.value < 1024 * 1024 * 1024) {
      final mb = totalSize.value / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} MB';
    } else {
      final gb = totalSize.value / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(1)} GB';
    }
  }
}
