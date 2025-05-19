import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/video_repository.dart';

/// Parameters for [DislikeVideo] use case
class DislikeVideoParams {
  /// Video ID
  final String videoId;

  /// Constructor
  const DislikeVideoParams({
    required this.videoId,
  });
}

/// Use case for disliking a video
class DislikeVideo implements UseCase<bool, DislikeVideoParams> {
  final VideoRepository repository;

  /// Constructor
  DislikeVideo(this.repository);

  @override
  Future<Either<Failure, bool>> call(DislikeVideoParams params) async {
    return await repository.dislikeVideo(params.videoId);
  }
}
