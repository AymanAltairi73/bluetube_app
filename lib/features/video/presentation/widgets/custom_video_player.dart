import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import '../controllers/video_controller.dart';

/// Custom video player widget with controls
class CustomVideoPlayer extends StatelessWidget {
  final VideoController controller;

  const CustomVideoPlayer({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isVideoInitialized.value) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.w,
              ),
            ),
          ),
        );
      }

      return AspectRatio(
        aspectRatio: controller.videoPlayerController!.value.aspectRatio,
        child: Stack(
          children: [
            // Video player
            GestureDetector(
              onTap: controller.toggleControls,
              child: VideoPlayer(controller.videoPlayerController!),
            ),

            // Buffering indicator
            if (controller.isBuffering.value)
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.w,
                ),
              ),

            // Video controls
            _buildVideoControls(),
          ],
        ),
      );
    });
  }

  Widget _buildVideoControls() {
    return Obx(() {
      return AnimatedOpacity(
        opacity: controller.isControlsVisible.value ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.5),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top controls (fullscreen button)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    controller.isFullScreen.value
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                    color: Colors.white,
                    size: 28.r,
                  ),
                  onPressed: controller.toggleFullScreen,
                ),
              ),

              // Bottom controls (play/pause, seek bar, time)
              Column(
                children: [
                  // Seek bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        // Current position
                        Text(
                          controller.formatDuration(Duration(
                            milliseconds: controller.currentPosition.value.toInt(),
                          )),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),

                        // Seek bar
                        Expanded(
                          child: Slider(
                            value: controller.currentPosition.value,
                            min: 0.0,
                            max: controller.duration.value,
                            onChanged: (value) {
                              controller.seekTo(Duration(
                                milliseconds: value.toInt(),
                              ));
                            },
                            activeColor: Colors.red,
                            inactiveColor: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),

                        // Total duration
                        Text(
                          controller.formatDuration(Duration(
                            milliseconds: controller.duration.value.toInt(),
                          )),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Play/pause button
                  IconButton(
                    icon: Icon(
                      controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 36.r,
                    ),
                    onPressed: controller.togglePlayPause,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
