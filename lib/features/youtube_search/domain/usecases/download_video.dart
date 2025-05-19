import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/downloaded_video.dart';
import '../entities/youtube_video.dart';
import '../repositories/downloads_repository.dart';

/// Parameters for [DownloadVideo] use case
class DownloadVideoParams {
  /// The video to download
  final YouTubeVideo video;

  /// The quality of the video to download
  final String quality;

  /// Constructor
  const DownloadVideoParams({
    required this.video,
    this.quality = '720p',
  });
}

/// Use case for downloading a video
class DownloadVideo implements UseCase<DownloadedVideo, DownloadVideoParams> {
  final DownloadsRepository repository;

  /// Constructor
  DownloadVideo(this.repository);

  @override
  Future<Either<Failure, DownloadedVideo>> call(DownloadVideoParams params) async {
    return await repository.downloadVideo(
      params.video,
      quality: params.quality,
    );
  }
}
