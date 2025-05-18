import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../../../core/errors/failures.dart';
import '../models/explore_category_model.dart';
import '../models/explore_video_model.dart';

/// Local data source for explore-related data
abstract class ExploreLocalDataSource {
  /// Get all explore categories
  Future<List<ExploreCategoryModel>> getExploreCategories();
  
  /// Get trending videos
  Future<List<ExploreVideoModel>> getTrendingVideos();
  
  /// Get videos by category
  Future<List<ExploreVideoModel>> getVideosByCategory(String categoryId);
}

/// Implementation of [ExploreLocalDataSource] using mock data
class ExploreLocalDataSourceImpl implements ExploreLocalDataSource {
  // In-memory cache of mock data
  List<Map<String, dynamic>>? _cachedCategories;
  Map<String, List<Map<String, dynamic>>>? _cachedVideos;
  final Random _random = Random();
  
  // Load mock categories data from JSON file
  Future<List<Map<String, dynamic>>> _loadCategoriesData() async {
    if (_cachedCategories != null) {
      return _cachedCategories!;
    }
    
    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/explore.json');
      final jsonData = json.decode(jsonString);
      
      // Extract the categories array
      _cachedCategories = List<Map<String, dynamic>>.from(jsonData['categories']);
      return _cachedCategories!;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      _cachedCategories = [
        {
          'id': 'cat001',
          'title': 'Trending',
          'icon': 'local_fire_department',
          'gradient_start': '#FF9800',
          'gradient_end': '#F44336'
        }
      ];
      return _cachedCategories!;
    }
  }
  
  // Load mock videos data from JSON file
  Future<Map<String, List<Map<String, dynamic>>>> _loadVideosData() async {
    if (_cachedVideos != null) {
      return _cachedVideos!;
    }
    
    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/explore.json');
      final jsonData = json.decode(jsonString);
      
      // Extract the videos arrays
      _cachedVideos = {
        'trending': List<Map<String, dynamic>>.from(jsonData['trending_videos']),
        'music': List<Map<String, dynamic>>.from(jsonData['music_videos']),
        'gaming': List<Map<String, dynamic>>.from(jsonData['gaming_videos']),
      };
      return _cachedVideos!;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      _cachedVideos = {
        'trending': [
          {
            'id': 'trend001',
            'title': 'Flutter Clean Architecture Tutorial',
            'thumbnail_url': 'assets/images/thumbnail.jpg',
            'channel_name': 'Flutter Dev',
            'channel_logo': 'assets/images/channel_avatar.png',
            'views': '245K',
            'time_ago': '2 weeks ago',
            'duration': '32:45',
            'is_live': false
          }
        ],
        'music': [],
        'gaming': [],
      };
      return _cachedVideos!;
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
  Future<List<ExploreCategoryModel>> getExploreCategories() async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadCategoriesData();
      return data.map((item) => ExploreCategoryModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get explore categories: ${e.toString()}');
    }
  }

  @override
  Future<List<ExploreVideoModel>> getTrendingVideos() async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideosData();
      final trendingVideos = data['trending'] ?? [];
      return trendingVideos.map((item) => ExploreVideoModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get trending videos: ${e.toString()}');
    }
  }

  @override
  Future<List<ExploreVideoModel>> getVideosByCategory(String categoryId) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideosData();
      
      // Map category ID to category name
      String categoryName;
      switch (categoryId) {
        case 'cat001':
          categoryName = 'trending';
          break;
        case 'cat002':
          categoryName = 'music';
          break;
        case 'cat003':
          categoryName = 'gaming';
          break;
        default:
          categoryName = 'trending';
      }
      
      final categoryVideos = data[categoryName] ?? [];
      return categoryVideos.map((item) => ExploreVideoModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get videos by category: ${e.toString()}');
    }
  }
}
