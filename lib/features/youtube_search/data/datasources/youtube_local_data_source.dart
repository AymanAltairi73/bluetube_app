import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/youtube_search_response_model.dart';
import '../models/youtube_video_details_response_model.dart';
import 'youtube_api_data_source.dart';

/// Implementation of [YouTubeApiDataSource] using local mock data
class YouTubeLocalDataSourceImpl implements YouTubeApiDataSource {
  // In-memory cache of mock data
  Map<String, dynamic>? _cachedSearchResults;
  Map<String, dynamic>? _cachedVideoDetails;
  Map<String, dynamic>? _cachedTrendingVideos;
  Map<String, dynamic>? _cachedVideosByCategory;
  Map<String, dynamic>? _cachedRelatedVideos;
  Map<String, dynamic>? _cachedComments;
  Map<String, dynamic>? _cachedChannelDetails;

  final Random _random = Random();

  // Load mock search results data from JSON file
  Future<Map<String, dynamic>> _loadSearchResultsData() async {
    if (_cachedSearchResults != null) {
      return _cachedSearchResults!;
    }

    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/search_results.json');
      _cachedSearchResults = json.decode(jsonString);
      return _cachedSearchResults!;
    } catch (e) {
      throw CacheException(message: 'Failed to load search results data: ${e.toString()}');
    }
  }

  // Load mock video details data from JSON file
  Future<Map<String, dynamic>> _loadVideoDetailsData() async {
    if (_cachedVideoDetails != null) {
      return _cachedVideoDetails!;
    }

    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/video_details.json');
      _cachedVideoDetails = json.decode(jsonString);
      return _cachedVideoDetails!;
    } catch (e) {
      throw CacheException(message: 'Failed to load video details data: ${e.toString()}');
    }
  }

  // Load mock trending videos data from JSON file
  Future<Map<String, dynamic>> _loadTrendingVideosData() async {
    if (_cachedTrendingVideos != null) {
      return _cachedTrendingVideos!;
    }

    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/trending_videos.json');
      _cachedTrendingVideos = json.decode(jsonString);
      return _cachedTrendingVideos!;
    } catch (e) {
      throw CacheException(message: 'Failed to load trending videos data: ${e.toString()}');
    }
  }

  // Load mock videos by category data from JSON file
  Future<Map<String, dynamic>> _loadVideosByCategoryData() async {
    if (_cachedVideosByCategory != null) {
      return _cachedVideosByCategory!;
    }

    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/videos_by_category.json');
      _cachedVideosByCategory = json.decode(jsonString);
      return _cachedVideosByCategory!;
    } catch (e) {
      throw CacheException(message: 'Failed to load videos by category data: ${e.toString()}');
    }
  }

  // Load mock related videos data from JSON file
  Future<Map<String, dynamic>> _loadRelatedVideosData() async {
    if (_cachedRelatedVideos != null) {
      return _cachedRelatedVideos!;
    }

    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/related_videos.json');
      _cachedRelatedVideos = json.decode(jsonString);
      return _cachedRelatedVideos!;
    } catch (e) {
      throw CacheException(message: 'Failed to load related videos data: ${e.toString()}');
    }
  }

  // Load mock comments data from JSON file
  Future<Map<String, dynamic>> _loadCommentsData() async {
    if (_cachedComments != null) {
      return _cachedComments!;
    }

    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/comments.json');
      _cachedComments = json.decode(jsonString);
      return _cachedComments!;
    } catch (e) {
      throw CacheException(message: 'Failed to load comments data: ${e.toString()}');
    }
  }

  // Load mock channel details data from JSON file
  Future<Map<String, dynamic>> _loadChannelDetailsData() async {
    if (_cachedChannelDetails != null) {
      return _cachedChannelDetails!;
    }

    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/channel_details.json');
      _cachedChannelDetails = json.decode(jsonString);
      return _cachedChannelDetails!;
    } catch (e) {
      throw CacheException(message: 'Failed to load channel details data: ${e.toString()}');
    }
  }

  // Simulate network delay with random duration
  Future<void> _simulateNetworkDelay() async {
    // Random delay between min and max network delay
    final delay = ApiConfig.minNetworkDelay +
        _random.nextInt(ApiConfig.maxNetworkDelay - ApiConfig.minNetworkDelay);
    await Future.delayed(Duration(milliseconds: delay));

    // Simulate random errors based on error probability
    if (_random.nextDouble() < ApiConfig.errorProbability) {
      throw ServerException(message: 'Network error occurred. Please try again.');
    }
  }

  @override
  Future<YouTubeSearchResponseModel> searchVideos(
    String query, {
    String? pageToken,
    int maxResults = 10,
  }) async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadSearchResultsData();
      return YouTubeSearchResponseModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to search videos: ${e.toString()}');
    }
  }

  @override
  Future<YouTubeVideoDetailsResponseModel> getVideoDetails(String videoId) async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadVideoDetailsData();

      // Find the video with the matching ID
      final items = data['items'] as List;
      final videoItem = items.firstWhere(
        (item) => item['id'] == videoId,
        orElse: () => items[0], // Fallback to the first video if not found
      );

      // Create a new response with just this video
      final response = {
        'kind': data['kind'],
        'etag': data['etag'],
        'items': [videoItem],
        'pageInfo': {
          'totalResults': 1,
          'resultsPerPage': 1,
        },
      };

      return YouTubeVideoDetailsResponseModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to get video details: ${e.toString()}');
    }
  }

  /// Get trending videos
  @override
  Future<YouTubeVideoDetailsResponseModel> getTrendingVideos() async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadTrendingVideosData();
      return YouTubeVideoDetailsResponseModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to get trending videos: ${e.toString()}');
    }
  }

  /// Get videos by category
  @override
  Future<YouTubeVideoDetailsResponseModel> getVideosByCategory(String categoryId) async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadVideosByCategoryData();
      return YouTubeVideoDetailsResponseModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to get videos by category: ${e.toString()}');
    }
  }

  /// Get related videos
  Future<YouTubeSearchResponseModel> getRelatedVideos(String videoId) async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadRelatedVideosData();
      return YouTubeSearchResponseModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to get related videos: ${e.toString()}');
    }
  }

  /// Get video comments
  @override
  Future<Map<String, dynamic>> getVideoComments(String videoId) async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadCommentsData();

      // Filter comments for the specific video
      final items = data['items'] as List;
      final videoComments = items.where(
        (item) => item['snippet']['videoId'] == videoId,
      ).toList();

      // Create a new response with just these comments
      final response = {
        'kind': data['kind'],
        'etag': data['etag'],
        'nextPageToken': data['nextPageToken'],
        'items': videoComments,
        'pageInfo': {
          'totalResults': videoComments.length,
          'resultsPerPage': videoComments.length,
        },
      };

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to get video comments: ${e.toString()}');
    }
  }

  /// Get channel details
  @override
  Future<Map<String, dynamic>> getChannelDetails(String channelId) async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadChannelDetailsData();

      // Find the channel with the matching ID
      final items = data['items'] as List;
      final channelItem = items.firstWhere(
        (item) => item['id'] == channelId,
        orElse: () => items[0], // Fallback to the first channel if not found
      );

      // Create a new response with just this channel
      final response = {
        'kind': data['kind'],
        'etag': data['etag'],
        'items': [channelItem],
        'pageInfo': {
          'totalResults': 1,
          'resultsPerPage': 1,
        },
      };

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to get channel details: ${e.toString()}');
    }
  }
}
