import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/downloaded_video.dart';
import '../entities/youtube_video.dart';
import '../repositories/downloads_repository.dart';

/// Use case for downloading a video
class DownloadVideo {
  final DownloadsRepository repository;

  /// Constructor
  DownloadVideo(this.repository);

  /// Download a video
  Future<Either<Failure, DownloadedVideo>> call(
    YouTubeVideo video, {
    String quality = '720p',
  }) async {
    return await repository.downloadVideo(video, quality: quality);
  }
}
