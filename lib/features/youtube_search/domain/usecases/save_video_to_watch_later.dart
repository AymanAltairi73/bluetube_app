import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_video.dart';
import '../repositories/watch_later_repository.dart';

/// Parameters for [SaveVideoToWatchLater] use case
class SaveVideoParams {
  /// The video to save
  final SavedVideo video;

  /// Constructor
  const SaveVideoParams({
    required this.video,
  });
}

/// Use case to save a video to watch later
class SaveVideoToWatchLater implements UseCase<bool, SaveVideoParams> {
  final WatchLaterRepository repository;

  /// Constructor
  SaveVideoToWatchLater(this.repository);

  @override
  Future<Either<Failure, bool>> call(SaveVideoParams params) {
    return repository.saveVideo(params.video);
  }
}
