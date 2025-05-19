import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/downloads_repository.dart';

/// Parameters for [DeleteDownloadedVideo] use case
class DeleteDownloadedVideoParams {
  /// Video ID
  final String videoId;

  /// Constructor
  const DeleteDownloadedVideoParams({
    required this.videoId,
  });
}

/// Use case for deleting a downloaded video
class DeleteDownloadedVideo implements UseCase<bool, DeleteDownloadedVideoParams> {
  final DownloadsRepository repository;

  /// Constructor
  DeleteDownloadedVideo(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteDownloadedVideoParams params) async {
    return await repository.deleteDownloadedVideo(params.videoId);
  }
}
