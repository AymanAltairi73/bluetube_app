import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pip_view/pip_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Widget for picture-in-picture video player
class PipVideoPlayer extends StatefulWidget {
  final String videoId;
  final VoidCallback? onClose;
  final VoidCallback? onExpand;
  final double? currentPosition;

  const PipVideoPlayer({
    super.key,
    required this.videoId,
    this.onClose,
    this.onExpand,
    this.currentPosition,
  });

  @override
  State<PipVideoPlayer> createState() => _PipVideoPlayerState();
}

class _PipVideoPlayerState extends State<PipVideoPlayer> with WidgetsBindingObserver {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  final RxBool _isPlaying = true.obs;
  final RxBool _isBuffering = false.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initPlayer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (state == AppLifecycleState.paused) {
      _controller.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (_isPlaying.value) {
        _controller.play();
      }
    }
  }

  void _initPlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: false,
        controlsVisibleAtStart: true,
        useHybridComposition: true,
        forceHD: false,
        enableCaption: true,
        disableDragSeek: false,
      ),
    )..addListener(_listener);

    // If we have a current position, seek to it
    if (widget.currentPosition != null && widget.currentPosition! > 0) {
      // We need to wait for the player to be ready before seeking
      Future.delayed(const Duration(seconds: 1), () {
        if (_isPlayerReady) {
          _controller.seekTo(Duration(seconds: widget.currentPosition!.toInt()));
        }
      });
    }
  }

  void _listener() {
    if (mounted) {
      // Update player state
      _isPlaying.value = _controller.value.isPlaying;
      _isBuffering.value = _controller.value.playerState == PlayerState.buffering;

      // Mark player as ready when it's initialized
      if (!_isPlayerReady && _controller.value.isReady) {
        _isPlayerReady = true;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    try {
      // Dispose player resources
      _controller.removeListener(_listener);
      _controller.dispose();
    } catch (e) {
      debugPrint('Error disposing YouTube player controller: $e');
    } finally {
      // Always remove the observer to prevent memory leaks
      try {
        WidgetsBinding.instance.removeObserver(this);
      } catch (e) {
        debugPrint('Error removing observer: $e');
      }
      super.dispose();
    }
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
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        onReady: () {
          _isPlayerReady = true;
          // If we have a current position, seek to it
          if (widget.currentPosition != null && widget.currentPosition! > 0) {
            _controller.seekTo(Duration(seconds: widget.currentPosition!.toInt()));
          }
        },
        bottomActions: [
          CurrentPosition(),
          const SizedBox(width: 10.0),
          ProgressBar(isExpanded: true),
          const SizedBox(width: 10.0),
          RemainingDuration(),
        ],
      ),
      builder: (context, player) {
        return PIPView(
          builder: (context, isFloating) {
            return Scaffold(
              appBar: !isFloating
                  ? AppBar(
                      title: const Text('Picture-in-Picture'),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          if (widget.onClose != null) {
                            // Pass the current position back to the main player
                            final position = _controller.value.position.inSeconds.toDouble();
                            Get.back(result: position);
                            widget.onClose!();
                          } else {
                            Get.back();
                          }
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: Obx(() => Icon(
                            _isPlaying.value ? Icons.pause : Icons.play_arrow,
                          )),
                          onPressed: () {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          },
                        ),
                      ],
                    )
                  : null,
              body: Column(
                children: [
                  Expanded(
                    child: player,
                  ),
                ],
              ),
              floatingActionButton: isFloating
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          heroTag: 'play_pause',
                          mini: true,
                          onPressed: () {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          },
                          child: Obx(() => Icon(
                            _isPlaying.value ? Icons.pause : Icons.play_arrow,
                          )),
                        ),
                        SizedBox(width: 8.w),
                        FloatingActionButton(
                          heroTag: 'expand',
                          mini: true,
                          onPressed: () {
                            if (widget.onExpand != null) {
                              // Pass the current position back to the main player
                              final position = _controller.value.position.inSeconds.toDouble();
                              Get.back(result: position);
                              widget.onExpand!();
                            } else {
                              Get.back();
                            }
                          },
                          child: const Icon(Icons.fullscreen),
                        ),
                      ],
                    )
                  : null,
            );
          },
          floatingWidth: MediaQuery.of(context).size.width * 0.4,
          floatingHeight: MediaQuery.of(context).size.width * 0.225, // 16:9 ratio
          initialCorner: PIPViewCorner.bottomRight,
          avoidKeyboard: true,
        );
      },
    );
  }
}
