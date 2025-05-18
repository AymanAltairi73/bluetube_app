import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/downloaded_video.dart';
import '../entities/youtube_video.dart';

/// Repository interface for downloaded videos operations
abstract class DownloadsRepository {
  /// Get all downloaded videos
  Future<Either<Failure, List<DownloadedVideo>>> getDownloadedVideos();

  /// Download a video
  Future<Either<Failure, DownloadedVideo>> downloadVideo(
    YouTubeVideo video, {
    String quality = '720p',
  });

  /// Delete a downloaded video
  Future<Either<Failure, bool>> deleteDownloadedVideo(String videoId);

  /// Check if a video is downloaded
  Future<Either<Failure, bool>> isVideoDownloaded(String videoId);
  
  /// Get a downloaded video by ID
  Future<Either<Failure, DownloadedVideo?>> getDownloadedVideo(String videoId);
  
  /// Get the total size of all downloaded videos
  Future<Either<Failure, int>> getTotalDownloadSize();
}
