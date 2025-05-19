import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/watch_later_repository.dart';

/// Parameters for [RemoveVideoFromWatchLater] use case
class RemoveVideoParams {
  /// The video ID to remove
  final String videoId;

  /// Constructor
  const RemoveVideoParams({
    required this.videoId,
  });
}

/// Use case to remove a video from watch later
class RemoveVideoFromWatchLater implements UseCase<bool, RemoveVideoParams> {
  final WatchLaterRepository repository;

  /// Constructor
  RemoveVideoFromWatchLater(this.repository);

  @override
  Future<Either<Failure, bool>> call(RemoveVideoParams params) {
    return repository.removeVideo(params.videoId);
  }
}
