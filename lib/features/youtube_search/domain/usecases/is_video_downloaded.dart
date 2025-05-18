import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/downloads_repository.dart';

/// Use case for checking if a video is downloaded
class IsVideoDownloaded {
  final DownloadsRepository repository;

  /// Constructor
  IsVideoDownloaded(this.repository);

  /// Check if a video is downloaded
  Future<Either<Failure, bool>> call(String videoId) async {
    return await repository.isVideoDownloaded(videoId);
  }
}
