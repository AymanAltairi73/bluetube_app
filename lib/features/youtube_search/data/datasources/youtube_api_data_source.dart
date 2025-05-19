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
}
