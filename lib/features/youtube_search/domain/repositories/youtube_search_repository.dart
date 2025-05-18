import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
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
  
  /// Get next page token from the last search
  String? getNextPageToken();
  
  /// Get previous page token from the last search
  String? getPrevPageToken();
  
  /// Get total results count from the last search
  int getTotalResults();
}
