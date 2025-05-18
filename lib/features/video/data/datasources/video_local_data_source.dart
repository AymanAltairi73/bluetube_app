import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../../../core/errors/failures.dart';
import '../models/video_detail_model.dart';
import '../models/comment_model.dart';
import '../models/related_video_model.dart';

/// Local data source for video-related data
abstract class VideoLocalDataSource {
  /// Get video details by ID
  Future<VideoDetailModel> getVideoDetail(String videoId);
  
  /// Get comments for a video
  Future<List<CommentModel>> getVideoComments(String videoId);
  
  /// Get related videos for a video
  Future<List<RelatedVideoModel>> getRelatedVideos(String videoId);
  
  /// Like a video
  Future<bool> likeVideo(String videoId);
  
  /// Dislike a video
  Future<bool> dislikeVideo(String videoId);
  
  /// Remove like/dislike from a video
  Future<bool> removeLikeDislike(String videoId);
  
  /// Subscribe to a channel
  Future<bool> subscribeToChannel(String channelId);
  
  /// Unsubscribe from a channel
  Future<bool> unsubscribeFromChannel(String channelId);
  
  /// Add a comment to a video
  Future<CommentModel> addComment(String videoId, String text);
  
  /// Like a comment
  Future<bool> likeComment(String commentId);
  
  /// Unlike a comment
  Future<bool> unlikeComment(String commentId);
}

/// Implementation of [VideoLocalDataSource] using mock data
class VideoLocalDataSourceImpl implements VideoLocalDataSource {
  // In-memory cache of mock data
  List<Map<String, dynamic>>? _cachedVideos;
  final Random _random = Random();
  
  // Load mock video data from JSON file
  Future<List<Map<String, dynamic>>> _loadVideoData() async {
    if (_cachedVideos != null) {
      return _cachedVideos!;
    }
    
    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/video_details.json');
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
          'description': 'Learn how to implement Clean Architecture in Flutter',
          'video_url': 'assets/videos/video_1.mp4',
          'thumbnail_url': 'assets/images/thumbnail.jpg',
          'channel_id': 'channel001',
          'channel_name': 'Flutter Dev',
          'channel_avatar': 'assets/images/channel_avatar.png',
          'views': 245000,
          'likes': 18500,
          'dislikes': 320,
          'published_at': '2023-05-15T10:30:00Z',
          'is_liked': false,
          'is_disliked': false,
          'is_subscribed': false,
          'subscriber_count': 850000,
          'tags': ['flutter', 'clean architecture', 'programming'],
          'category': 'Education',
          'is_live': false,
          'comments': [],
          'related_videos': []
        }
      ];
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
  Future<VideoDetailModel> getVideoDetail(String videoId) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideoData();
      final videoData = data.firstWhere(
        (video) => video['id'] == videoId,
        orElse: () => throw CacheFailure(message: 'Video not found'),
      );
      
      return VideoDetailModel.fromJson(videoData);
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get video details: ${e.toString()}');
    }
  }

  @override
  Future<List<CommentModel>> getVideoComments(String videoId) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideoData();
      final videoData = data.firstWhere(
        (video) => video['id'] == videoId,
        orElse: () => throw CacheFailure(message: 'Video not found'),
      );
      
      final comments = List<Map<String, dynamic>>.from(videoData['comments'] ?? []);
      return comments.map((comment) => CommentModel.fromJson(comment)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get video comments: ${e.toString()}');
    }
  }

  @override
  Future<List<RelatedVideoModel>> getRelatedVideos(String videoId) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideoData();
      final videoData = data.firstWhere(
        (video) => video['id'] == videoId,
        orElse: () => throw CacheFailure(message: 'Video not found'),
      );
      
      final relatedVideos = List<Map<String, dynamic>>.from(videoData['related_videos'] ?? []);
      return relatedVideos.map((video) => RelatedVideoModel.fromJson(video)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get related videos: ${e.toString()}');
    }
  }

  @override
  Future<bool> likeVideo(String videoId) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideoData();
      final videoIndex = data.indexWhere((video) => video['id'] == videoId);
      
      if (videoIndex == -1) {
        throw CacheFailure(message: 'Video not found');
      }
      
      // Update the video data
      data[videoIndex]['is_liked'] = true;
      data[videoIndex]['is_disliked'] = false;
      data[videoIndex]['likes'] = (data[videoIndex]['likes'] as int) + 1;
      
      // If the video was previously disliked, decrement the dislike count
      if (data[videoIndex]['is_disliked'] == true) {
        data[videoIndex]['dislikes'] = (data[videoIndex]['dislikes'] as int) - 1;
      }
      
      return true;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to like video: ${e.toString()}');
    }
  }

  @override
  Future<bool> dislikeVideo(String videoId) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideoData();
      final videoIndex = data.indexWhere((video) => video['id'] == videoId);
      
      if (videoIndex == -1) {
        throw CacheFailure(message: 'Video not found');
      }
      
      // Update the video data
      data[videoIndex]['is_disliked'] = true;
      data[videoIndex]['is_liked'] = false;
      data[videoIndex]['dislikes'] = (data[videoIndex]['dislikes'] as int) + 1;
      
      // If the video was previously liked, decrement the like count
      if (data[videoIndex]['is_liked'] == true) {
        data[videoIndex]['likes'] = (data[videoIndex]['likes'] as int) - 1;
      }
      
      return true;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to dislike video: ${e.toString()}');
    }
  }

  @override
  Future<bool> removeLikeDislike(String videoId) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideoData();
      final videoIndex = data.indexWhere((video) => video['id'] == videoId);
      
      if (videoIndex == -1) {
        throw CacheFailure(message: 'Video not found');
      }
      
      // Update the video data
      final wasLiked = data[videoIndex]['is_liked'] == true;
      final wasDisliked = data[videoIndex]['is_disliked'] == true;
      
      data[videoIndex]['is_liked'] = false;
      data[videoIndex]['is_disliked'] = false;
      
      // Update the counts
      if (wasLiked) {
        data[videoIndex]['likes'] = (data[videoIndex]['likes'] as int) - 1;
      }
      
      if (wasDisliked) {
        data[videoIndex]['dislikes'] = (data[videoIndex]['dislikes'] as int) - 1;
      }
      
      return true;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to remove like/dislike: ${e.toString()}');
    }
  }

  @override
  Future<bool> subscribeToChannel(String channelId) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideoData();
      final videosForChannel = data.where((video) => video['channel_id'] == channelId).toList();
      
      for (var video in videosForChannel) {
        video['is_subscribed'] = true;
        video['subscriber_count'] = (video['subscriber_count'] as int) + 1;
      }
      
      return videosForChannel.isNotEmpty;
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
      final data = await _loadVideoData();
      final videosForChannel = data.where((video) => video['channel_id'] == channelId).toList();
      
      for (var video in videosForChannel) {
        video['is_subscribed'] = false;
        video['subscriber_count'] = (video['subscriber_count'] as int) - 1;
      }
      
      return videosForChannel.isNotEmpty;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to unsubscribe from channel: ${e.toString()}');
    }
  }

  @override
  Future<CommentModel> addComment(String videoId, String text) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideoData();
      final videoIndex = data.indexWhere((video) => video['id'] == videoId);
      
      if (videoIndex == -1) {
        throw CacheFailure(message: 'Video not found');
      }
      
      // Create a new comment
      final commentId = 'comment${DateTime.now().millisecondsSinceEpoch}';
      final newComment = {
        'id': commentId,
        'video_id': videoId,
        'user_id': 'current_user',
        'user_name': 'Current User',
        'user_avatar': 'assets/images/profile.png',
        'text': text,
        'created_at': DateTime.now().toIso8601String(),
        'likes': 0,
        'replies': 0,
        'is_liked': false,
        'is_pinned': false,
        'is_owner': true,
      };
      
      // Add the comment to the video
      if (data[videoIndex]['comments'] == null) {
        data[videoIndex]['comments'] = [];
      }
      
      data[videoIndex]['comments'].insert(0, newComment);
      
      return CommentModel.fromJson(newComment);
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to add comment: ${e.toString()}');
    }
  }

  @override
  Future<bool> likeComment(String commentId) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideoData();
      
      // Find the comment in all videos
      for (var video in data) {
        if (video['comments'] == null) continue;
        
        final comments = List<Map<String, dynamic>>.from(video['comments']);
        final commentIndex = comments.indexWhere((comment) => comment['id'] == commentId);
        
        if (commentIndex != -1) {
          // Update the comment
          comments[commentIndex]['is_liked'] = true;
          comments[commentIndex]['likes'] = (comments[commentIndex]['likes'] as int) + 1;
          return true;
        }
      }
      
      throw CacheFailure(message: 'Comment not found');
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to like comment: ${e.toString()}');
    }
  }

  @override
  Future<bool> unlikeComment(String commentId) async {
    await _simulateNetworkDelay();
    
    try {
      final data = await _loadVideoData();
      
      // Find the comment in all videos
      for (var video in data) {
        if (video['comments'] == null) continue;
        
        final comments = List<Map<String, dynamic>>.from(video['comments']);
        final commentIndex = comments.indexWhere((comment) => comment['id'] == commentId);
        
        if (commentIndex != -1) {
          // Update the comment
          comments[commentIndex]['is_liked'] = false;
          comments[commentIndex]['likes'] = (comments[commentIndex]['likes'] as int) - 1;
          return true;
        }
      }
      
      throw CacheFailure(message: 'Comment not found');
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to unlike comment: ${e.toString()}');
    }
  }
}
