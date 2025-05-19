import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/watch_later_repository.dart';

/// Parameters for [CheckVideoSavedStatus] use case
class CheckVideoSavedParams {
  /// The video ID to check
  final String videoId;

  /// Constructor
  const CheckVideoSavedParams({
    required this.videoId,
  });
}

/// Use case to check if a video is saved to watch later
class CheckVideoSavedStatus implements UseCase<bool, CheckVideoSavedParams> {
  final WatchLaterRepository repository;

  /// Constructor
  CheckVideoSavedStatus(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckVideoSavedParams params) {
    return repository.isVideoSaved(params.videoId);
  }
}
