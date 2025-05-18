import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../../../core/errors/failures.dart';
import '../models/channel_model.dart';
import '../models/subscription_video_model.dart';
import '../models/subscription_filter_model.dart';

/// Local data source for subscription-related data
abstract class SubscriptionLocalDataSource {
  /// Get all subscribed channels
  Future<List<ChannelModel>> getSubscribedChannels();
  
  /// Get videos from subscribed channels
  Future<List<SubscriptionVideoModel>> getSubscriptionVideos();
  
  /// Get videos from subscribed channels filtered by a specific filter
  Future<List<SubscriptionVideoModel>> getFilteredSubscriptionVideos(String filter);
  
  /// Get available filters for subscription videos
  Future<List<SubscriptionFilterModel>> getSubscriptionFilters();
  
  /// Subscribe to a channel
  Future<bool> subscribeToChannel(String channelId);
  
  /// Unsubscribe from a channel
  Future<bool> unsubscribeFromChannel(String channelId);
}

/// Implementation of [SubscriptionLocalDataSource] using mock data
class SubscriptionLocalDataSourceImpl implements SubscriptionLocalDataSource {
  // In-memory cache of mock data
  List<Map<String, dynamic>>? _cachedChannels;
  List<Map<String, dynamic>>? _cachedVideos;
  List<String>? _cachedFilters;
  final Random _random = Random();
  
  // Load mock channels data from JSON file
  Future<List<Map<String, dynamic>>> _loadChannelsData() async {
    if (_cachedChannels != null) {
      return _cachedChannels!;
    }
    
    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/subscriptions.json');
      final jsonData = json.decode(jsonString);
      
      // Extract the channels array
      _cachedChannels = List<Map<String, dynamic>>.from(jsonData['channels']);
      return _cachedChannels!;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      _cachedChannels = [
        {
          'id': 'channel001',
          'name': 'Flutter Mastery',
          'image': 'assets/images/channel_avatar.png',
          'subscribers': 1250000,
          'has_new_content': true,
          'is_verified': true,
          'description': 'Flutter tutorials and tips for mobile app development.'
        }
      ];
      return _cachedChannels!;
    }
  }
  
  // Load mock videos data from JSON file
  Future<List<Map<String, dynamic>>> _loadVideosData() async {
    if (_cachedVideos != null) {
      return _cachedVideos!;
    }
    
    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/subscriptions.json');
      final jsonData = json.decode(jsonString);
      
      // Extract the videos array
      _cachedVideos = List<Map<String, dynamic>>.from(jsonData['videos']);
      return _cachedVideos!;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      _cachedVideos = [
        {
          'id': 'sub_vid001',
          'title': 'Flutter Clean Architecture Tutorial',
          'thumbnail_url': 'assets/images/thumbnail.jpg',
          'channel_id': 'channel001',
          'channel_name': 'Flutter Mastery',
          'channel_avatar': 'assets/images/channel_avatar.png',
          'views': 245000,
          'published_at': '2023-05-15T10:30:00Z',
          'duration': '32:45',
          'is_short': false,
          'is_live': false
        }
      ];
      return _cachedVideos!;
    }
  }
  
  // Load mock filters data from JSON file
  Future<List<String>> _loadFiltersData() async {
    if (_cachedFilters != null) {
      return _cachedFilters!;
    }
    
    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/subscriptions.json');
      final jsonData = json.decode(jsonString);
      
      // Extract the filters array
      _cachedFilters = List<String>.from(jsonData['filters']);
      return _cachedFilters!;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      _cachedFilters = ['All', 'Today', 'Yesterday', 'This week', 'This month'];
      return _cachedFilters!;
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
  Future<List<ChannelModel>> getSubscribedChannels() async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadChannelsData();
      return data.map((item) => ChannelModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get subscribed channels: ${e.toString()}');
    }
  }

  @override
  Future<List<SubscriptionVideoModel>> getSubscriptionVideos() async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideosData();
      return data.map((item) => SubscriptionVideoModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get subscription videos: ${e.toString()}');
    }
  }

  @override
  Future<List<SubscriptionVideoModel>> getFilteredSubscriptionVideos(String filter) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideosData();
      
      // If filter is 'All', return all videos
      if (filter.toLowerCase() == 'all') {
        return data.map((item) => SubscriptionVideoModel.fromJson(item)).toList();
      }
      
      // For other filters, we'll simulate filtering by returning a subset of videos
      // In a real app, you would apply actual filtering logic based on the filter
      switch (filter) {
        case 'Today':
          // Return videos published today
          final today = DateTime.now().toUtc().subtract(const Duration(hours: 24));
          return data
              .where((item) => DateTime.parse(item['published_at']).isAfter(today))
              .map((item) => SubscriptionVideoModel.fromJson(item))
              .toList();
        case 'Yesterday':
          // Return videos published yesterday
          final yesterday = DateTime.now().toUtc().subtract(const Duration(hours: 48));
          final today = DateTime.now().toUtc().subtract(const Duration(hours: 24));
          return data
              .where((item) => 
                DateTime.parse(item['published_at']).isAfter(yesterday) && 
                DateTime.parse(item['published_at']).isBefore(today))
              .map((item) => SubscriptionVideoModel.fromJson(item))
              .toList();
        case 'This week':
          // Return videos published this week
          final thisWeek = DateTime.now().toUtc().subtract(const Duration(days: 7));
          return data
              .where((item) => DateTime.parse(item['published_at']).isAfter(thisWeek))
              .map((item) => SubscriptionVideoModel.fromJson(item))
              .toList();
        case 'This month':
          // Return videos published this month
          final thisMonth = DateTime.now().toUtc().subtract(const Duration(days: 30));
          return data
              .where((item) => DateTime.parse(item['published_at']).isAfter(thisMonth))
              .map((item) => SubscriptionVideoModel.fromJson(item))
              .toList();
        case 'Continue watching':
          // Return a random subset of videos to simulate "Continue watching"
          return data
              .take(2)
              .map((item) => SubscriptionVideoModel.fromJson(item))
              .toList();
        default:
          // Return all videos for unknown filters
          return data.map((item) => SubscriptionVideoModel.fromJson(item)).toList();
      }
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get filtered subscription videos: ${e.toString()}');
    }
  }

  @override
  Future<List<SubscriptionFilterModel>> getSubscriptionFilters() async {
    await _simulateNetworkDelay();
    
    try {
      final filters = await _loadFiltersData();
      return filters.map((name) => SubscriptionFilterModel.fromJson(name, isSelected: name == 'All')).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get subscription filters: ${e.toString()}');
    }
  }

  @override
  Future<bool> subscribeToChannel(String channelId) async {
    await _simulateNetworkDelay();
    
    try {
      final channels = await _loadChannelsData();
      final channelIndex = channels.indexWhere((item) => item['id'] == channelId);
      
      if (channelIndex != -1) {
        // Channel already exists, nothing to do
        return true;
      }
      
      // In a real app, you would add the channel to the subscribed channels list
      // For this mock implementation, we'll just return true
      return true;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to subscribe to channel: ${e.toString()}');
    }
  }

  @override
  Future<bool> unsubscribeFromChannel(String channelId) async {
    await _simulateNetworkDelay();
    
    try {
      final channels = await _loadChannelsData();
      final channelIndex = channels.indexWhere((item) => item['id'] == channelId);
      
      if (channelIndex != -1) {
        // In a real app, you would remove the channel from the subscribed channels list
        // For this mock implementation, we'll just return true
        return true;
      }
      
      return false;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to unsubscribe from channel: ${e.toString()}');
    }
  }
}
