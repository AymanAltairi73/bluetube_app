import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../../../core/errors/failures.dart';
import '../models/video_model.dart';
import '../models/category_model.dart';

/// Local data source for home-related data
abstract class HomeLocalDataSource {
  /// Get all videos for the home feed
  Future<List<VideoModel>> getVideos();

  /// Get videos by category
  Future<List<VideoModel>> getVideosByCategory(String category);

  /// Get all available categories
  Future<List<CategoryModel>> getCategories();

  /// Get trending videos
  Future<List<VideoModel>> getTrendingVideos();

  /// Get recommended videos based on user preferences
  Future<List<VideoModel>> getRecommendedVideos();
}

/// Implementation of [HomeLocalDataSource] using mock data
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  // In-memory cache of mock data
  List<Map<String, dynamic>>? _cachedVideos;
  List<String>? _cachedCategories;
  final Random _random = Random();

  // Load mock video data from JSON file
  Future<List<Map<String, dynamic>>> _loadVideoData() async {
    if (_cachedVideos != null) {
      return _cachedVideos!;
    }

    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/home_videos.json');
      final jsonData = json.decode(jsonString);

      // Extract the videos array
      _cachedVideos = List<Map<String, dynamic>>.from(jsonData['videos']);
      return _cachedVideos!;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      _cachedVideos = [
        {
          'id': 'vid001',
          'title': 'Flutter Clean Architecture Tutorial',
          'thumbnail_url': 'assets/images/thumbnail.jpg',
          'channel_name': 'Flutter Dev',
          'channel_avatar': 'assets/images/channel_avatar.png',
          'views': 245000,
          'published_at': '2023-05-15T10:30:00Z',
          'duration': '32:45',
          'likes': 18500,
          'dislikes': 320,
          'is_live': false,
          'description': 'Learn how to implement Clean Architecture in Flutter'
        }
      ];
      return _cachedVideos!;
    }
  }

  // Load mock category data from JSON file
  Future<List<String>> _loadCategoryData() async {
    if (_cachedCategories != null) {
      return _cachedCategories!;
    }

    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/home_videos.json');
      final jsonData = json.decode(jsonString);

      // Extract the categories array
      _cachedCategories = List<String>.from(jsonData['categories']);
      return _cachedCategories!;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      _cachedCategories = ['All', 'Music', 'Gaming', 'Flutter', 'Programming'];
      return _cachedCategories!;
    }
  }

  // Simulate network delay with random duration
  Future<void> _simulateNetworkDelay() async {
    // Random delay between 200ms and 800ms
    final delay = 200 + _random.nextInt(600);
    await Future.delayed(Duration(milliseconds: delay));

    // Simulate random errors (10% chance)
    if (_random.nextDouble() < 0.1) {
      throw CacheFailure(message: 'Network error occurred. Please try again.');
    }
  }

  @override
  Future<List<VideoModel>> getVideos() async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadVideoData();
      return data.map((item) => VideoModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get videos: ${e.toString()}');
    }
  }

  @override
  Future<List<VideoModel>> getVideosByCategory(String category) async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadVideoData();

      // If category is 'All', return all videos
      if (category.toLowerCase() == 'all') {
        return data.map((item) => VideoModel.fromJson(item)).toList();
      }

      // Filter videos by category (in a real app, videos would have a category field)
      // For mock data, we'll just return a subset of videos
      final filteredData = data.where((item) => data.indexOf(item) % 3 == 0).toList();
      return filteredData.map((item) => VideoModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get videos by category: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    await _simulateNetworkDelay();

    try {
      final categories = await _loadCategoryData();
      return categories.map((name) => CategoryModel.fromJson(name, isSelected: name == 'All')).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get categories: ${e.toString()}');
    }
  }

  @override
  Future<List<VideoModel>> getTrendingVideos() async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadVideoData();
      // Sort by views to get trending videos
      final sortedData = List<Map<String, dynamic>>.from(data)
        ..sort((a, b) => (b['views'] as int).compareTo(a['views'] as int));

      // Return top 5 videos
      return sortedData.take(5).map((item) => VideoModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get trending videos: ${e.toString()}');
    }
  }

  @override
  Future<List<VideoModel>> getRecommendedVideos() async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadVideoData();
      // Shuffle videos to simulate recommendations
      final shuffledData = List<Map<String, dynamic>>.from(data)..shuffle(_random);

      // Return top 5 videos
      return shuffledData.take(5).map((item) => VideoModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get recommended videos: ${e.toString()}');
    }
  }
}
