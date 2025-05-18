import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_repository.dart';

/// Use case for removing like/dislike from a video
class RemoveLikeDislike {
  final VideoRepository repository;

  RemoveLikeDislike(this.repository);

  Future<Either<Failure, bool>> call(String videoId) async {
    return await repository.removeLikeDislike(videoId);
  }
}
