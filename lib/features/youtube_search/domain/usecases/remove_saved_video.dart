import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/watch_later_repository.dart';

/// Use case for removing a video from Watch Later
class RemoveSavedVideo {
  final WatchLaterRepository repository;

  /// Constructor
  RemoveSavedVideo(this.repository);

  /// Remove a video from Watch Later
  Future<Either<Failure, bool>> call(String videoId) async {
    return await repository.removeVideo(videoId);
  }
}
