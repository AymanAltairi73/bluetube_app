import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/video_repository.dart';

/// Parameters for [LikeVideo] use case
class LikeVideoParams {
  /// Video ID
  final String videoId;

  /// Constructor
  const LikeVideoParams({
    required this.videoId,
  });
}

/// Use case for liking a video
class LikeVideo implements UseCase<bool, LikeVideoParams> {
  final VideoRepository repository;

  /// Constructor
  LikeVideo(this.repository);

  @override
  Future<Either<Failure, bool>> call(LikeVideoParams params) async {
    return await repository.likeVideo(params.videoId);
  }
}
