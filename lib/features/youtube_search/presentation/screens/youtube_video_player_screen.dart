import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../app/routes/app_routes.dart';
import '../controllers/youtube_search_controller.dart';
import '../controllers/watch_later_controller.dart';
import '../controllers/downloads_controller.dart';
import '../../domain/entities/youtube_video.dart';
import '../widgets/enhanced_video_controls.dart';
import '../widgets/pip_video_player.dart';

/// Screen for playing YouTube videos
class YouTubeVideoPlayerScreen extends StatefulWidget {
  final String videoId;

  const YouTubeVideoPlayerScreen({
    super.key,
    required this.videoId,
  });

  @override
  State<YouTubeVideoPlayerScreen> createState() => _YouTubeVideoPlayerScreenState();
}

class _YouTubeVideoPlayerScreenState extends State<YouTubeVideoPlayerScreen> {
  late YoutubePlayerController _playerController;
  late YouTubeSearchController _searchController;
  late WatchLaterController _watchLaterController;
  YouTubeVideo? _videoDetails;
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isPlayerReady = false;
  final RxBool _isVideoSaved = false.obs;
  final RxBool _isInPipMode = false.obs;
  final RxBool _isDownloaded = false.obs;

  @override
  void initState() {
    super.initState();
    _searchController = Get.find<YouTubeSearchController>();
    _watchLaterController = Get.find<WatchLaterController>();

    // Try to find DownloadsController if it's registered
    try {
      final downloadsController = Get.find<DownloadsController>();
      // Check if video is downloaded
      downloadsController.checkIfVideoIsDownloaded(widget.videoId).then((isDownloaded) {
        _isDownloaded.value = isDownloaded;
      });
    } catch (e) {
      // DownloadsController not registered yet, ignore
    }

    _initPlayer();
    _loadVideoDetails();
    _checkIfVideoIsSaved();
  }

  Future<void> _checkIfVideoIsSaved() async {
    final isSaved = await _watchLaterController.checkIfVideoIsSaved(widget.videoId);
    _isVideoSaved.value = isSaved;
  }

  void _initPlayer() {
    // Validate video ID
    if (widget.videoId.isEmpty) {
      setState(() {
        _errorMessage = 'Invalid video ID';
        _isLoading = false;
      });
      return;
    }

    try {
      // Validate that the video ID is in the correct format
      if (!RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(widget.videoId)) {
        setState(() {
          _errorMessage = 'Invalid YouTube video ID format';
          _isLoading = false;
        });
        return;
      }

      _playerController = YoutubePlayerController(
        initialVideoId: widget.videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          useHybridComposition: true,
          forceHD: false,
          loop: false,
          isLive: false,
          disableDragSeek: false,
          hideControls: false,
          hideThumbnail: false,
          controlsVisibleAtStart: true,
        ),
      )..addListener(_playerListener);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize player: ${e.toString()}';
        _isLoading = false;
      });
      debugPrint('Error initializing YouTube player: $e');
    }
  }

  void _playerListener() {
    if (_isPlayerReady && mounted && !_playerController.value.isFullScreen) {
      setState(() {});
    }
  }

  Future<void> _loadVideoDetails() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final videoDetails = await _searchController.getVideoById(widget.videoId);

      if (!mounted) return;

      if (videoDetails == null) {
        setState(() {
          _errorMessage = 'Video details not found';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _videoDetails = videoDetails;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Failed to load video details: ${e.toString()}';
        _isLoading = false;
      });

      // Log the error for debugging
      debugPrint('Error loading video details: $e');
    }
  }

  @override
  void dispose() {
    // Pause the player before disposing to prevent audio issues
    if (_isPlayerReady) {
      _playerController.pause();
    }

    // Remove listener first to prevent callbacks after disposal
    try {
      _playerController.removeListener(_playerListener);
    } catch (e) {
      debugPrint('Error removing listener: $e');
    }

    // Dispose player resources
    try {
      _playerController.dispose();
    } catch (e) {
      debugPrint('Error disposing YouTube player controller: $e');
    }

    super.dispose();
  }

  @override
  void deactivate() {
    // Pauses video when navigating to another screen
    _playerController.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen.
        // This overrides the behavior.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _playerController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          // When video ends, show a message and seek to beginning
          _playerController.seekTo(const Duration(seconds: 0));
          _playerController.pause();

          // Show a snackbar with options
          Get.snackbar(
            'Video Ended',
            'Would you like to replay or see related videos?',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
            mainButton: TextButton(
              onPressed: () {
                _playerController.play();
              },
              child: const Text('Replay'),
            ),
          );
        },
        topActions: [
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _videoDetails?.title ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        bottomActions: [
          CurrentPosition(),
          const SizedBox(width: 10.0),
          ProgressBar(
            isExpanded: true,
            colors: const ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.redAccent,
            ),
          ),
          const SizedBox(width: 10.0),
          RemainingDuration(),
          EnhancedVideoControls(
            controller: _playerController,
            onTogglePictureInPicture: _togglePictureInPictureMode,
          ),
          FullScreenButton(),
        ],
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: const Text('Video Player'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          actions: [
            Obx(() => IconButton(
              icon: Icon(
                _isVideoSaved.value
                    ? Icons.watch_later
                    : Icons.watch_later_outlined,
                color: _isVideoSaved.value ? Colors.blue : null,
              ),
              onPressed: _saveToWatchLater,
              tooltip: _isVideoSaved.value
                  ? 'Remove from Watch Later'
                  : 'Save to Watch Later',
            )),
            IconButton(
              icon: const Icon(Icons.playlist_add),
              onPressed: () => Get.toNamed(AppRoutes.watchLater),
              tooltip: 'Watch Later List',
            ),
            Obx(() => IconButton(
              icon: Icon(
                _isDownloaded.value
                    ? Icons.download_done
                    : Icons.download_outlined,
                color: _isDownloaded.value ? Colors.green : null,
              ),
              onPressed: _downloadVideo,
              tooltip: _isDownloaded.value
                  ? 'Remove Download'
                  : 'Download for Offline',
            )),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareVideo,
              tooltip: 'Share',
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video player
            player,

            // Video details
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                      ? _buildErrorView()
                      : _buildVideoDetails(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoDetails() {
    if (_videoDetails == null) {
      return const Center(child: Text('No video details available'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            _videoDetails!.title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),

          // Stats
          Row(
            children: [
              Text(
                _videoDetails!.formattedViewCount,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '•',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                _videoDetails!.formattedPublishedDate,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Channel
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.grey[300],
                child: Text(
                  _videoDetails!.channelTitle[0],
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _videoDetails!.channelTitle,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Subscribe to channel
                },
                child: const Text('Subscribe'),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Description
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              _videoDetails!.description,
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.r,
            color: Colors.red,
          ),
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
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _loadVideoDetails,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _saveToWatchLater() async {
    if (_videoDetails == null) {
      Get.snackbar(
        'Error',
        'Video details not available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final success = await _watchLaterController.toggleSaveStatus(_videoDetails!);

    if (success) {
      // Update local state
      _isVideoSaved.value = !_isVideoSaved.value;
    }
  }

  void _shareVideo() {
    if (_videoDetails == null) {
      Get.snackbar(
        'Error',
        'Video details not available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final videoUrl = 'https://www.youtube.com/watch?v=${widget.videoId}';

    // Show a snackbar with the video URL
    Get.snackbar(
      'Share Video',
      'Copy this link: $videoUrl',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      mainButton: TextButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: videoUrl));
          Get.snackbar(
            'Copied',
            'Video link copied to clipboard',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        },
        child: const Text('Copy'),
      ),
    );
  }

  void _togglePictureInPictureMode() async {
    // Prevent multiple calls while transitioning
    if (!mounted) return;

    // Toggle PIP mode state
    final bool enteringPipMode = !_isInPipMode.value;

    if (enteringPipMode) {
      try {
        // Update state before starting the transition
        _isInPipMode.value = true;

        // Get current position before pausing
        final currentPosition = _playerController.value.position.inSeconds.toDouble();
        final bool wasPlaying = _playerController.value.isPlaying;

        // Pause the current player to prevent audio overlap
        if (_isPlayerReady) {
          _playerController.pause();
        }

        // Save player state before navigating
        final String videoId = widget.videoId;

        // Navigate to PIP screen
        final result = await Get.to<double>(
          () => PipVideoPlayer(
            videoId: videoId,
            currentPosition: currentPosition,
            onClose: () {
              // This will be called when PIP is closed
              if (mounted) {
                _isInPipMode.value = false;
              }
            },
            onExpand: () {
              // This will be called when PIP is expanded
              if (mounted) {
                _isInPipMode.value = false;
              }
            },
          ),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 300),
        );

        // Check if the widget is still mounted before proceeding
        if (!mounted) return;

        // Reset PIP mode state
        _isInPipMode.value = false;

        // If we got a position back, seek to it
        if (result != null && _isPlayerReady) {
          try {
            _playerController.seekTo(Duration(seconds: result.toInt()));

            // Resume playback only if it was playing before
            if (wasPlaying) {
              _playerController.play();
            }
          } catch (seekError) {
            debugPrint('Error seeking to position: $seekError');
          }
        }
      } catch (e) {
        // Handle any exceptions
        if (mounted) {
          _isInPipMode.value = false;
          Get.snackbar(
            'Error',
            'Failed to enter picture-in-picture mode: ${e.toString()}',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        debugPrint('Error toggling PIP mode: $e');
      }
    } else {
      // Just update state if we're exiting PIP mode
      _isInPipMode.value = false;
    }
  }

  void _downloadVideo() {
    if (!mounted) return;

    if (_videoDetails == null) {
      Get.snackbar(
        'Error',
        'Video details not available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final downloadsController = Get.find<DownloadsController>();

      if (_isDownloaded.value) {
        // Delete the downloaded video
        Get.dialog(
          AlertDialog(
            title: const Text('Remove Download'),
            content: const Text('Are you sure you want to remove this downloaded video?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  _deleteDownloadedVideo(downloadsController);
                },
                child: const Text('Remove'),
              ),
            ],
          ),
        );
      } else {
        // Show quality selection dialog
        Get.dialog(
          AlertDialog(
            title: const Text('Select Quality'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('720p (HD)'),
                  onTap: () {
                    Get.back();
                    _startDownload(downloadsController, '720p');
                  },
                ),
                ListTile(
                  title: const Text('480p (SD)'),
                  onTap: () {
                    Get.back();
                    _startDownload(downloadsController, '480p');
                  },
                ),
                ListTile(
                  title: const Text('360p (Low)'),
                  onTap: () {
                    Get.back();
                    _startDownload(downloadsController, '360p');
                  },
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      // DownloadsController not registered yet
      Get.snackbar(
        'Downloads Not Available',
        'Please try again later',
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('Error accessing downloads controller: $e');
    }
  }

  void _deleteDownloadedVideo(DownloadsController controller) {
    if (!mounted || _videoDetails == null) return;

    controller.deleteVideo(_videoDetails!.id).then((success) {
      if (!mounted) return;

      if (success) {
        _isDownloaded.value = false;
        Get.snackbar(
          'Success',
          'Video removed from downloads',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to remove download',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }).catchError((error) {
      if (!mounted) return;

      Get.snackbar(
        'Error',
        'Failed to remove download: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('Error deleting downloaded video: $error');
    });
  }

  void _startDownload(DownloadsController controller, String quality) {
    if (!mounted || _videoDetails == null) return;

    controller.downloadYouTubeVideo(_videoDetails!, quality: quality).then((success) {
      if (!mounted) return;

      if (success) {
        _isDownloaded.value = true;
        Get.snackbar(
          'Success',
          'Video downloaded successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to download video',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }).catchError((error) {
      if (!mounted) return;

      Get.snackbar(
        'Error',
        'Failed to download video: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('Error downloading video: $error');
    });
  }
}
