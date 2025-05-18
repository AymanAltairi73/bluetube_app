import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/saved_video.dart';
import '../repositories/watch_later_repository.dart';

/// Use case for getting saved videos
class GetSavedVideos {
  final WatchLaterRepository repository;

  /// Constructor
  GetSavedVideos(this.repository);

  /// Get all saved videos
  Future<Either<Failure, List<SavedVideo>>> call() async {
    return await repository.getSavedVideos();
  }
}
