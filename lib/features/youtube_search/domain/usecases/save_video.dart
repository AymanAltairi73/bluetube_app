import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_video.dart';
import '../repositories/watch_later_repository.dart';

/// Parameters for [SaveVideo] use case
class SaveVideoParams {
  /// The video to save
  final SavedVideo video;

  /// Constructor
  const SaveVideoParams({
    required this.video,
  });
}

/// Use case for saving a video to Watch Later
class SaveVideo implements UseCase<bool, SaveVideoParams> {
  final WatchLaterRepository repository;

  /// Constructor
  SaveVideo(this.repository);

  @override
  Future<Either<Failure, bool>> call(SaveVideoParams params) async {
    return await repository.saveVideo(params.video);
  }
}
