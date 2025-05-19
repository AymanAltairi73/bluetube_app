import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/watch_later_repository.dart';

/// Parameters for [IsVideoSaved] use case
class IsVideoSavedParams {
  /// Video ID
  final String videoId;

  /// Constructor
  const IsVideoSavedParams({
    required this.videoId,
  });
}

/// Use case for checking if a video is saved
class IsVideoSaved implements UseCase<bool, IsVideoSavedParams> {
  final WatchLaterRepository repository;

  /// Constructor
  IsVideoSaved(this.repository);

  @override
  Future<Either<Failure, bool>> call(IsVideoSavedParams params) async {
    return await repository.isVideoSaved(params.videoId);
  }
}
