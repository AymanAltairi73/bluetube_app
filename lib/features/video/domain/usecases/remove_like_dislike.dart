import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/video_repository.dart';

/// Parameters for [RemoveLikeDislike] use case
class RemoveLikeDislikeParams {
  /// Video ID
  final String videoId;

  /// Constructor
  const RemoveLikeDislikeParams({
    required this.videoId,
  });
}

/// Use case for removing like/dislike from a video
class RemoveLikeDislike implements UseCase<bool, RemoveLikeDislikeParams> {
  final VideoRepository repository;

  /// Constructor
  RemoveLikeDislike(this.repository);

  @override
  Future<Either<Failure, bool>> call(RemoveLikeDislikeParams params) async {
    return await repository.removeLikeDislike(params.videoId);
  }
}
