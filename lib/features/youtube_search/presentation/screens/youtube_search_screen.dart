import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../controllers/youtube_search_controller.dart';
import '../widgets/youtube_video_card.dart';

/// Screen for searching YouTube videos
class YouTubeSearchScreen extends StatefulWidget {
  const YouTubeSearchScreen({super.key});

  @override
  State<YouTubeSearchScreen> createState() => _YouTubeSearchScreenState();
}

class _YouTubeSearchScreenState extends State<YouTubeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late YouTubeSearchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<YouTubeSearchController>();

    // Add scroll listener for pagination
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.h) {
      _controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),

          // Results
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

              return _buildSearchResults();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search YouTube videos',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 16.w,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _controller.clearSearch();
                        },
                      )
                    : null,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _controller.search(value);
                }
              },
            ),
          ),
          SizedBox(width: 8.w),
          ElevatedButton(
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                _controller.search(_searchController.text);
              }
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return RefreshIndicator(
      onRefresh: () async {
        if (_controller.searchQuery.isNotEmpty) {
          await _controller.search(_controller.searchQuery.value);
        }
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: _controller.videos.length + (_controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _controller.videos.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: const CircularProgressIndicator(),
              ),
            );
          }

          final video = _controller.videos[index];
          return YouTubeVideoCard(
            video: video,
            onTap: () {
              Get.toNamed(
                AppRoutes.youtubeVideoPlayer,
                parameters: {'videoId': video.id},
              );
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
            Icons.search,
            size: 64.r,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'Search for YouTube videos',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Enter a search term to find videos',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
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
            onPressed: () {
              if (_controller.searchQuery.isNotEmpty) {
                _controller.search(_controller.searchQuery.value);
              }
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
