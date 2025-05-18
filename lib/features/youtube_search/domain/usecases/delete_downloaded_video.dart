import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/downloads_repository.dart';

/// Use case for deleting a downloaded video
class DeleteDownloadedVideo {
  final DownloadsRepository repository;

  /// Constructor
  DeleteDownloadedVideo(this.repository);

  /// Delete a downloaded video
  Future<Either<Failure, bool>> call(String videoId) async {
    return await repository.deleteDownloadedVideo(videoId);
  }
}
