import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/saved_video.dart';
import '../repositories/watch_later_repository.dart';

/// Use case for saving a video to Watch Later
class SaveVideo {
  final WatchLaterRepository repository;

  /// Constructor
  SaveVideo(this.repository);

  /// Save a video to Watch Later
  Future<Either<Failure, bool>> call(SavedVideo video) async {
    return await repository.saveVideo(video);
  }
}
