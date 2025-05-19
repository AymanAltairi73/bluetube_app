import 'package:get/get.dart';
import '../../../../core/config/api_config.dart';
import '../../domain/entities/youtube_video.dart';
import '../../domain/usecases/search_videos.dart';
import '../../domain/usecases/get_video_details.dart';

/// Controller for YouTube search functionality
class YouTubeSearchController extends GetxController {
  final SearchVideos searchVideos;
  final GetYouTubeVideoDetails getVideoDetails;

  YouTubeSearchController({
    required this.searchVideos,
    required this.getVideoDetails,
  });

  // Observable variables
  final RxList<YouTubeVideo> videos = <YouTubeVideo>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxBool hasMoreResults = true.obs;

  // Pagination variables
  String? _nextPageToken;
  String? _prevPageToken;
  int _totalResults = 0;

  /// Search for videos by query
  Future<void> search(String query) async {
    if (query.isEmpty) {
      return;
    }

    // Reset state
    videos.clear();
    isLoading.value = true;
    errorMessage.value = '';
    searchQuery.value = query;
    _nextPageToken = null;
    _prevPageToken = null;
    _totalResults = 0;
    hasMoreResults.value = true;

    final result = await searchVideos(
      SearchVideosParams(
        query: query,
        maxResults: ApiConfig.defaultMaxResults,
      ),
    );

    isLoading.value = false;

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (videosList) {
        videos.addAll(videosList);
        _checkHasMoreResults();
      },
    );
  }

  /// Load more search results
  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !hasMoreResults.value) {
      return;
    }

    isLoadingMore.value = true;

    final result = await searchVideos(
      SearchVideosParams(
        query: searchQuery.value,
        pageToken: _nextPageToken,
        maxResults: ApiConfig.defaultMaxResults,
      ),
    );

    isLoadingMore.value = false;

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (videosList) {
        videos.addAll(videosList);
        _checkHasMoreResults();
      },
    );
  }

  /// Get video details by ID
  Future<YouTubeVideo?> getVideoById(String videoId) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getVideoDetails(GetVideoDetailsParams(videoId: videoId));

    isLoading.value = false;

    return result.fold(
      (failure) {
        errorMessage.value = failure.message;
        return null;
      },
      (video) => video,
    );
  }

  /// Check if there are more results to load
  void _checkHasMoreResults() {
    hasMoreResults.value = _nextPageToken != null && videos.length < _totalResults;
  }

  /// Clear search results
  void clearSearch() {
    videos.clear();
    searchQuery.value = '';
    errorMessage.value = '';
    _nextPageToken = null;
    _prevPageToken = null;
    _totalResults = 0;
    hasMoreResults.value = true;
  }
}
