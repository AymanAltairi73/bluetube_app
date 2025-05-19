import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_video.dart';
import '../repositories/watch_later_repository.dart';

/// Use case for getting saved videos
class GetSavedVideos implements UseCase<List<SavedVideo>, NoParams> {
  final WatchLaterRepository repository;

  /// Constructor
  GetSavedVideos(this.repository);

  @override
  Future<Either<Failure, List<SavedVideo>>> call(NoParams params) async {
    return await repository.getSavedVideos();
  }
}
