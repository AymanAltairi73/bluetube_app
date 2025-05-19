import '../../../../core/config/api_config.dart';
import '../models/youtube_search_response_model.dart';
import '../models/youtube_video_details_response_model.dart';

/// Abstract class for YouTube API data source
abstract class YouTubeApiDataSource {
  /// Search for videos by query
  Future<YouTubeSearchResponseModel> searchVideos(
    String query, {
    String? pageToken,
    int maxResults = ApiConfig.defaultMaxResults,
  });

  /// Get video details by ID
  Future<YouTubeVideoDetailsResponseModel> getVideoDetails(String videoId);

  /// Get channel details by ID
  Future<Map<String, dynamic>> getChannelDetails(String channelId);

  /// Get trending videos
  Future<YouTubeVideoDetailsResponseModel> getTrendingVideos();

  /// Get videos by category
  Future<YouTubeVideoDetailsResponseModel> getVideosByCategory(String categoryId);

  /// Get video comments
  Future<Map<String, dynamic>> getVideoComments(String videoId);

  /// Get related videos for a video
  Future<YouTubeSearchResponseModel> getRelatedVideos(String videoId);
}
