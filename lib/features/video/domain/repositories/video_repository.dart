import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/video_detail.dart';
import '../entities/comment.dart';
import '../entities/related_video.dart';

/// Repository interface for video-related operations
abstract class VideoRepository {
  /// Get video details by ID
  Future<Either<Failure, VideoDetail>> getVideoDetail(String videoId);
  
  /// Get comments for a video
  Future<Either<Failure, List<Comment>>> getVideoComments(String videoId);
  
  /// Get related videos for a video
  Future<Either<Failure, List<RelatedVideo>>> getRelatedVideos(String videoId);
  
  /// Like a video
  Future<Either<Failure, bool>> likeVideo(String videoId);
  
  /// Dislike a video
  Future<Either<Failure, bool>> dislikeVideo(String videoId);
  
  /// Remove like/dislike from a video
  Future<Either<Failure, bool>> removeLikeDislike(String videoId);
  
  /// Subscribe to a channel
  Future<Either<Failure, bool>> subscribeToChannel(String channelId);
  
  /// Unsubscribe from a channel
  Future<Either<Failure, bool>> unsubscribeFromChannel(String channelId);
  
  /// Add a comment to a video
  Future<Either<Failure, Comment>> addComment(String videoId, String text);
  
  /// Like a comment
  Future<Either<Failure, bool>> likeComment(String commentId);
  
  /// Unlike a comment
  Future<Either<Failure, bool>> unlikeComment(String commentId);
}
