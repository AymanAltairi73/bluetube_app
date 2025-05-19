import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/watch_later_repository.dart';

/// Parameters for [RemoveSavedVideo] use case
class RemoveSavedVideoParams {
  /// Video ID
  final String videoId;

  /// Constructor
  const RemoveSavedVideoParams({
    required this.videoId,
  });
}

/// Use case for removing a video from Watch Later
class RemoveSavedVideo implements UseCase<bool, RemoveSavedVideoParams> {
  final WatchLaterRepository repository;

  /// Constructor
  RemoveSavedVideo(this.repository);

  @override
  Future<Either<Failure, bool>> call(RemoveSavedVideoParams params) async {
    return await repository.removeVideo(params.videoId);
  }
}
