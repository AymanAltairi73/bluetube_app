import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../controllers/downloads_controller.dart';
import '../widgets/downloaded_video_card.dart';

/// Screen for downloaded videos
class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  late DownloadsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<DownloadsController>();
    _controller.loadDownloadedVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed(AppRoutes.youtubeSearch),
            tooltip: 'Search Videos',
          ),
        ],
      ),
      body: Column(
        children: [
          // Storage info
          Obx(() => Container(
            padding: EdgeInsets.all(16.r),
            color: Colors.grey[100],
            child: Row(
              children: [
                Icon(
                  Icons.storage,
                  size: 24.r,
                  color: Colors.blue,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Storage Used',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${_controller.formattedTotalSize} • ${_controller.videos.length} videos',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Show storage management options
                    _showStorageManagementDialog();
                  },
                  child: const Text('Manage'),
                ),
              ],
            ),
          )),

          // Download progress indicator
          Obx(() => _controller.isDownloading.value
              ? Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  color: Colors.blue[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.download_rounded,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Downloading...',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${(_controller.downloadProgress.value * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      LinearProgressIndicator(
                        value: _controller.downloadProgress.value,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),

          // Video list
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value && _controller.videos.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_controller.errorMessage.isNotEmpty && _controller.videos.isEmpty) {
                return _buildErrorView(_controller.errorMessage.value);
              }

              if (_controller.videos.isEmpty) {
                return _buildEmptyView();
              }

              return _buildVideoList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () => _controller.loadDownloadedVideos(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: _controller.videos.length,
        itemBuilder: (context, index) {
          final video = _controller.videos[index];
          return DownloadedVideoCard(
            video: video,
            onTap: () {
              // Play the downloaded video
              // In a real app, this would play the local file
              Get.toNamed(
                AppRoutes.youtubeVideoPlayer,
                parameters: {'videoId': video.id},
              );
            },
            onDelete: () async {
              await _controller.deleteVideo(video.id);
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
            Icons.download_rounded,
            size: 64.r,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No downloaded videos',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Videos you download will appear here',
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
            onPressed: () => _controller.loadDownloadedVideos(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showStorageManagementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Management'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: const Text('Delete All Downloads'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteAllConfirmation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort),
              title: const Text('Sort by Size'),
              onTap: () {
                Navigator.pop(context);
                _controller.videos.sort((a, b) => b.fileSize.compareTo(a.fileSize));
              },
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Sort by Date'),
              onTap: () {
                Navigator.pop(context);
                _controller.videos.sort((a, b) => b.downloadedAt.compareTo(a.downloadedAt));
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Downloads'),
        content: const Text('Are you sure you want to delete all downloaded videos? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllDownloads();
            },
            child: const Text('Delete All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAllDownloads() async {
    // Copy the list to avoid modification during iteration
    final videos = List.from(_controller.videos);
    for (final video in videos) {
      await _controller.deleteVideo(video.id);
    }
  }
}
