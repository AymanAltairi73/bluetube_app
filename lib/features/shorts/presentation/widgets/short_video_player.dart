import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/short.dart';

/// Widget to display a short video player
class ShortVideoPlayer extends StatefulWidget {
  final Short short;
  final bool autoPlay;

  const ShortVideoPlayer({
    super.key,
    required this.short,
    this.autoPlay = true,
  });

  @override
  State<ShortVideoPlayer> createState() => _ShortVideoPlayerState();
}

class _ShortVideoPlayerState extends State<ShortVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void didUpdateWidget(ShortVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.short.videoUrl != widget.short.videoUrl) {
      _disposeVideoPlayer();
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    // For now, we'll use a network URL for demonstration
    // In a real app, you would use the actual video URL from the short
    _controller = VideoPlayerController.asset(widget.short.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          if (widget.autoPlay) {
            _controller.play();
            _controller.setLooping(true);
            _isPlaying = true;
          }
        });
      });
  }

  void _disposeVideoPlayer() {
    _controller.dispose();
    _isInitialized = false;
    _isPlaying = false;
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    _disposeVideoPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player
          _isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3.w,
                  ),
                ),

          // Play/pause indicator
          if (!_isPlaying && _isInitialized)
            Center(
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 48.r,
                ),
              ),
            ),

          // Video info overlay at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.short.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12.r,
                        backgroundImage: AssetImage(widget.short.authorAvatar),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        widget.short.author,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
