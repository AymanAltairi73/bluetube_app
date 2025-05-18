import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/downloaded_video.dart';
import '../repositories/downloads_repository.dart';

/// Use case for getting downloaded videos
class GetDownloadedVideos {
  final DownloadsRepository repository;

  /// Constructor
  GetDownloadedVideos(this.repository);

  /// Get all downloaded videos
  Future<Either<Failure, List<DownloadedVideo>>> call() async {
    return await repository.getDownloadedVideos();
  }
}
