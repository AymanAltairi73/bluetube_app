import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/youtube_channel.dart';
import '../entities/youtube_comment.dart';
import '../entities/youtube_video.dart';

/// Repository interface for YouTube search operations
abstract class YouTubeSearchRepository {
  /// Search for videos by query
  Future<Either<Failure, List<YouTubeVideo>>> searchVideos(
    String query, {
    String? pageToken,
    int maxResults,
  });

  /// Get video details by ID
  Future<Either<Failure, YouTubeVideo>> getVideoDetails(String videoId);

  /// Get channel details by ID
  Future<Either<Failure, YouTubeChannel>> getChannelDetails(String channelId);

  /// Get trending videos
  Future<Either<Failure, List<YouTubeVideo>>> getTrendingVideos({
    String regionCode,
    String? categoryId,
    int maxResults,
    String? pageToken,
  });

  /// Get videos by category
  Future<Either<Failure, List<YouTubeVideo>>> getVideosByCategory(
    String categoryId, {
    int maxResults,
    String? pageToken,
  });

  /// Get video comments
  Future<Either<Failure, List<YouTubeComment>>> getVideoComments(
    String videoId, {
    int maxResults,
    String? pageToken,
  });

  /// Get related videos for a video
  Future<Either<Failure, List<YouTubeVideo>>> getRelatedVideos(
    String videoId, {
    int maxResults,
    String? pageToken,
  });

  /// Get next page token from the last search
  String? getNextPageToken();

  /// Get previous page token from the last search
  String? getPrevPageToken();

  /// Get total results count from the last search
  int getTotalResults();
}
