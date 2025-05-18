import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/watch_later_repository.dart';

/// Use case for checking if a video is saved
class IsVideoSaved {
  final WatchLaterRepository repository;

  /// Constructor
  IsVideoSaved(this.repository);

  /// Check if a video is saved
  Future<Either<Failure, bool>> call(String videoId) async {
    return await repository.isVideoSaved(videoId);
  }
}
