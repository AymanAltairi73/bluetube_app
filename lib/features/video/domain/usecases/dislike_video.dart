import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_repository.dart';

/// Use case for disliking a video
class DislikeVideo {
  final VideoRepository repository;

  DislikeVideo(this.repository);

  Future<Either<Failure, bool>> call(String videoId) async {
    return await repository.dislikeVideo(videoId);
  }
}
