import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../../../core/errors/failures.dart';
import '../models/short_model.dart';

/// Local data source for shorts-related data
abstract class ShortsLocalDataSource {
  /// Get all shorts
  Future<List<ShortModel>> getShorts();
  
  /// Get shorts by author
  Future<List<ShortModel>> getShortsByAuthor(String author);
  
  /// Like a short
  Future<bool> likeShort(String shortId);
  
  /// Unlike a short
  Future<bool> unlikeShort(String shortId);
  
  /// Subscribe to an author
  Future<bool> subscribeToAuthor(String author);
  
  /// Unsubscribe from an author
  Future<bool> unsubscribeFromAuthor(String author);
}

/// Implementation of [ShortsLocalDataSource] using mock data
class ShortsLocalDataSourceImpl implements ShortsLocalDataSource {
  // In-memory cache of mock data
  List<Map<String, dynamic>>? _cachedShorts;
  final Random _random = Random();
  
  // Load mock shorts data from JSON file
  Future<List<Map<String, dynamic>>> _loadShortsData() async {
    if (_cachedShorts != null) {
      return _cachedShorts!;
    }
    
    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/shorts.json');
      final jsonData = json.decode(jsonString);
      
      // Extract the shorts array
      _cachedShorts = List<Map<String, dynamic>>.from(jsonData['shorts']);
      return _cachedShorts!;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      _cachedShorts = [
        {
          'id': 'short001',
          'title': 'Flutter Animation in 30 Seconds #shorts',
          'video_url': 'assets/videos/short_1.mp4',
          'thumbnail_url': 'assets/images/short_thumbnail.jpg',
          'author': 'Flutter Mastery',
          'author_avatar': 'assets/images/channel_avatar.png',
          'likes': 189000,
          'comments': 743,
          'shares': 12400,
          'is_subscribed': true,
          'music': 'Coding Beats - Developer Mix',
          'description': 'Learn this cool Flutter animation in just 30 seconds! #flutter #coding #shorts'
        }
      ];
      return _cachedShorts!;
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
  Future<List<ShortModel>> getShorts() async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadShortsData();
      return data.map((item) => ShortModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get shorts: ${e.toString()}');
    }
  }

  @override
  Future<List<ShortModel>> getShortsByAuthor(String author) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadShortsData();
      final filteredData = data.where((item) => item['author'] == author).toList();
      return filteredData.map((item) => ShortModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get shorts by author: ${e.toString()}');
    }
  }

  @override
  Future<bool> likeShort(String shortId) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadShortsData();
      final shortIndex = data.indexWhere((item) => item['id'] == shortId);
      
      if (shortIndex != -1) {
        data[shortIndex]['likes'] = data[shortIndex]['likes'] + 1;
        return true;
      }
      
      return false;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to like short: ${e.toString()}');
    }
  }

  @override
  Future<bool> unlikeShort(String shortId) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadShortsData();
      final shortIndex = data.indexWhere((item) => item['id'] == shortId);
      
      if (shortIndex != -1) {
        data[shortIndex]['likes'] = data[shortIndex]['likes'] - 1;
        return true;
      }
      
      return false;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to unlike short: ${e.toString()}');
    }
  }

  @override
  Future<bool> subscribeToAuthor(String author) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadShortsData();
      final shortsForAuthor = data.where((item) => item['author'] == author).toList();
      
      for (var short in shortsForAuthor) {
        short['is_subscribed'] = true;
      }
      
      return shortsForAuthor.isNotEmpty;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to subscribe to author: ${e.toString()}');
    }
  }

  @override
  Future<bool> unsubscribeFromAuthor(String author) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadShortsData();
      final shortsForAuthor = data.where((item) => item['author'] == author).toList();
      
      for (var short in shortsForAuthor) {
        short['is_subscribed'] = false;
      }
      
      return shortsForAuthor.isNotEmpty;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to unsubscribe from author: ${e.toString()}');
    }
  }
}
