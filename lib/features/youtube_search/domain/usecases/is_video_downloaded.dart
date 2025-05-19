import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/downloads_repository.dart';

/// Parameters for [IsVideoDownloaded] use case
class IsVideoDownloadedParams {
  /// Video ID
  final String videoId;

  /// Constructor
  const IsVideoDownloadedParams({
    required this.videoId,
  });
}

/// Use case for checking if a video is downloaded
class IsVideoDownloaded implements UseCase<bool, IsVideoDownloadedParams> {
  final DownloadsRepository repository;

  /// Constructor
  IsVideoDownloaded(this.repository);

  @override
  Future<Either<Failure, bool>> call(IsVideoDownloadedParams params) async {
    return await repository.isVideoDownloaded(params.videoId);
  }
}
