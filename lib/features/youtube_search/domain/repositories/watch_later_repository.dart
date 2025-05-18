import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/saved_video.dart';

/// Repository interface for Watch Later operations
abstract class WatchLaterRepository {
  /// Get all saved videos
  Future<Either<Failure, List<SavedVideo>>> getSavedVideos();

  /// Save a video to Watch Later
  Future<Either<Failure, bool>> saveVideo(SavedVideo video);

  /// Remove a video from Watch Later
  Future<Either<Failure, bool>> removeVideo(String videoId);

  /// Check if a video is saved
  Future<Either<Failure, bool>> isVideoSaved(String videoId);
}
