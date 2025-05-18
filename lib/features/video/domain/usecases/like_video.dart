import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_repository.dart';

/// Use case for liking a video
class LikeVideo {
  final VideoRepository repository;

  LikeVideo(this.repository);

  Future<Either<Failure, bool>> call(String videoId) async {
    return await repository.likeVideo(videoId);
  }
}
