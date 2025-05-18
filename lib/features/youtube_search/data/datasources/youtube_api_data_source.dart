import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/exceptions.dart';
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

/// Implementation of [YouTubeApiDataSource] using HTTP client
class YouTubeApiDataSourceImpl implements YouTubeApiDataSource {
  final http.Client client;

  /// Constructor
  YouTubeApiDataSourceImpl({required this.client});

  @override
  Future<YouTubeSearchResponseModel> searchVideos(
    String query, {
    String? pageToken,
    int maxResults = ApiConfig.defaultMaxResults,
  }) async {
    try {
      final queryParams = {
        'part': ApiConfig.defaultSearchPart,
        'q': query,
        'type': ApiConfig.defaultSearchType,
        'maxResults': maxResults.toString(),
        'key': ApiConfig.youtubeApiKey,
      };

      if (pageToken != null) {
        queryParams['pageToken'] = pageToken;
      }

      final uri = Uri.parse('${ApiConfig.youtubeBaseUrl}/search')
          .replace(queryParameters: queryParams);

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        return YouTubeSearchResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['error']?['message'] ?? 'Unknown API error';
        final errorReason = errorBody['error']?['errors']?.first?['reason'] ?? '';
        final errorDomain = errorBody['error']?['errors']?.first?['domain'] ?? '';

        throw ServerException(
          message: '$errorMessage (Reason: $errorReason, Domain: $errorDomain)',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to search videos: ${e.toString()}',
      );
    }
  }

  @override
  Future<YouTubeVideoDetailsResponseModel> getVideoDetails(
    String videoId,
  ) async {
    try {
      final uri = Uri.parse('${ApiConfig.youtubeBaseUrl}/videos').replace(
        queryParameters: {
          'part': ApiConfig.defaultVideoPart,
          'id': videoId,
          'key': ApiConfig.youtubeApiKey,
        },
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        return YouTubeVideoDetailsResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['error']?['message'] ?? 'Unknown API error';
        final errorReason = errorBody['error']?['errors']?.first?['reason'] ?? '';
        final errorDomain = errorBody['error']?['errors']?.first?['domain'] ?? '';

        throw ServerException(
          message: '$errorMessage (Reason: $errorReason, Domain: $errorDomain)',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to get video details: ${e.toString()}',
      );
    }
  }
}
