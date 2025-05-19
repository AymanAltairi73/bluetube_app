import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../../../core/config/api_config.dart';
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
  Future<Map<String, dynamic>> _loadVideoData() async {
    if (_cachedVideos != null) {
      return {'items': _cachedVideos!};
    }

    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/video_details.json');
      final jsonData = json.decode(jsonString);

      // Extract the videos array
      _cachedVideos = List<Map<String, dynamic>>.from(jsonData['items']);
      return jsonData;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      _cachedVideos = [
        {
          'id': 'video001',
          'snippet': {
            'title': 'Flutter 3.0 - What\'s New and Amazing Features',
            'description': 'Flutter 3.0 is here with amazing new features!',
            'publishedAt': '2023-06-15T14:00:00Z',
            'channelId': 'channel001',
            'channelTitle': 'Flutter Dev',
            'thumbnails': {
              'default': {
                'url': 'assets/images/thumbnails/flutter_3.jpg'
              },
              'medium': {
                'url': 'assets/images/thumbnails/flutter_3.jpg'
              },
              'high': {
                'url': 'assets/images/thumbnails/flutter_3.jpg'
              }
            }
          },
          'contentDetails': {
            'duration': 'PT15M33S'
          },
          'statistics': {
            'viewCount': '1245678',
            'likeCount': '98765',
            'dislikeCount': '0',
            'commentCount': '12345'
          }
        }
      ];
      return {'items': _cachedVideos!};
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
      throw CacheFailure(message: 'Network error occurred. Please try again.');
    }
  }

  @override
  Future<VideoDetailModel> getVideoDetail(String videoId) async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadVideoData();
      final items = data['items'] as List;

      // Find the video with the matching ID
      final videoItem = items.firstWhere(
        (item) => item['id'] == videoId,
        orElse: () => throw CacheFailure(message: 'Video not found'),
      );

      // Convert to VideoDetailModel
      return VideoDetailModel(
        id: videoItem['id'],
        title: videoItem['snippet']['title'],
        description: videoItem['snippet']['description'],
        videoUrl: 'assets/videos/video_1.mp4', // Mock video URL
        thumbnailUrl: videoItem['snippet']['thumbnails']['high']['url'],
        channelId: videoItem['snippet']['channelId'],
        channelName: videoItem['snippet']['channelTitle'],
        channelAvatar: 'assets/images/channel_avatar.png', // Mock channel avatar
        views: int.parse(videoItem['statistics']['viewCount']),
        likes: int.parse(videoItem['statistics']['likeCount']),
        dislikes: int.parse(videoItem['statistics']['dislikeCount']),
        publishedAt: DateTime.parse(videoItem['snippet']['publishedAt']),
        isLiked: false, // Mock state
        isDisliked: false, // Mock state
        isSubscribed: false, // Mock state
        subscriberCount: 1000000, // Mock subscriber count
        tags: videoItem['snippet']['tags'] != null
          ? List<String>.from(videoItem['snippet']['tags'])
          : [],
        category: 'Education', // Mock category
        isLive: false, // Mock live status
      );
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
      // Load comments from the comments.json file
      final jsonString = await rootBundle.loadString('assets/mock_data/comments.json');
      final jsonData = json.decode(jsonString);

      final items = jsonData['items'] as List;

      // Filter comments for the specific video
      final videoComments = items.where(
        (item) => item['snippet']['videoId'] == videoId,
      ).toList();

      // Convert to CommentModel list
      return videoComments.map((comment) {
        final topLevelComment = comment['snippet']['topLevelComment'];
        return CommentModel(
          id: comment['id'],
          videoId: comment['snippet']['videoId'],
          userId: topLevelComment['snippet']['authorChannelId']['value'],
          userName: topLevelComment['snippet']['authorDisplayName'],
          userAvatar: topLevelComment['snippet']['authorProfileImageUrl'],
          text: topLevelComment['snippet']['textDisplay'],
          createdAt: DateTime.parse(topLevelComment['snippet']['publishedAt']),
          likes: topLevelComment['snippet']['likeCount'],
          replies: comment['snippet']['totalReplyCount'],
          isLiked: topLevelComment['snippet']['viewerRating'] == 'like',
          isPinned: false, // Mock pinned status
          isOwner: false, // Mock owner status
        );
      }).toList();
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
      // Load related videos from the related_videos.json file
      final jsonString = await rootBundle.loadString('assets/mock_data/related_videos.json');
      final jsonData = json.decode(jsonString);

      final items = jsonData['items'] as List;

      // Convert to RelatedVideoModel list
      return items.map((video) {
        return RelatedVideoModel(
          id: video['id']['videoId'],
          title: video['snippet']['title'],
          thumbnailUrl: video['snippet']['thumbnails']['high']['url'],
          channelName: video['snippet']['channelTitle'],
          channelAvatar: 'assets/images/channel_avatar.png', // Mock channel avatar
          views: 100000 + _random.nextInt(900000), // Mock view count
          publishedAt: DateTime.parse(video['snippet']['publishedAt']),
          duration: 'PT${5 + _random.nextInt(25)}M${_random.nextInt(60)}S', // Mock duration
          isLive: false, // Mock live status
        );
      }).toList();
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
      // In a real implementation, this would update the video's like status
      // For mock data, we'll just return success
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
      // In a real implementation, this would update the video's dislike status
      // For mock data, we'll just return success
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
      // In a real implementation, this would remove the video's like/dislike status
      // For mock data, we'll just return success
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
      // In a real implementation, this would subscribe to the channel
      // For mock data, we'll just return success
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
      // In a real implementation, this would unsubscribe from the channel
      // For mock data, we'll just return success
      return true;
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
      // Create a new comment
      final commentId = 'comment${DateTime.now().millisecondsSinceEpoch}';

      return CommentModel(
        id: commentId,
        videoId: videoId,
        userId: 'current_user',
        userName: 'Current User',
        userAvatar: 'assets/images/profile.png',
        text: text,
        createdAt: DateTime.now(),
        likes: 0,
        replies: 0,
        isLiked: false,
        isPinned: false,
        isOwner: true,
      );
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
      // In a real implementation, this would like the comment
      // For mock data, we'll just return success
      return true;
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
      // In a real implementation, this would unlike the comment
      // For mock data, we'll just return success
      return true;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to unlike comment: ${e.toString()}');
    }
  }
}
