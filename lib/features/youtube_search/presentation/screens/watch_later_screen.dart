import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../controllers/watch_later_controller.dart';
import '../widgets/saved_video_card.dart';

/// Screen for Watch Later videos
class WatchLaterScreen extends StatefulWidget {
  const WatchLaterScreen({super.key});

  @override
  State<WatchLaterScreen> createState() => _WatchLaterScreenState();
}

class _WatchLaterScreenState extends State<WatchLaterScreen> {
  late WatchLaterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<WatchLaterController>();
    _controller.loadSavedVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch Later'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage.isNotEmpty) {
          return _buildErrorView(_controller.errorMessage.value);
        }

        if (_controller.videos.isEmpty) {
          return _buildEmptyView();
        }

        return _buildVideoList();
      }),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () => _controller.loadSavedVideos(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: _controller.videos.length,
        itemBuilder: (context, index) {
          final video = _controller.videos[index];
          return SavedVideoCard(
            video: video,
            onTap: () {
              Get.toNamed(
                AppRoutes.youtubeVideoPlayer,
                parameters: {'videoId': video.id},
              );
            },
            onRemove: () async {
              await _controller.removeVideoFromWatchLater(video.id);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.watch_later_outlined,
            size: 64.r,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No saved videos',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Videos you save will appear here',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.youtubeSearch),
            child: const Text('Search Videos'),
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
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => _controller.loadSavedVideos(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
