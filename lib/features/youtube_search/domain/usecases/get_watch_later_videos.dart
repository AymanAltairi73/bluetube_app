import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_video.dart';
import '../repositories/watch_later_repository.dart';

/// Use case to get all videos saved to watch later
class GetWatchLaterVideos implements UseCase<List<SavedVideo>, NoParams> {
  final WatchLaterRepository repository;

  /// Constructor
  GetWatchLaterVideos(this.repository);

  @override
  Future<Either<Failure, List<SavedVideo>>> call(NoParams params) {
    return repository.getSavedVideos();
  }
}
