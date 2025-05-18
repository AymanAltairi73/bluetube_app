import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/comment.dart';
import '../repositories/video_repository.dart';

/// Use case for getting comments for a video
class GetVideoComments {
  final VideoRepository repository;

  GetVideoComments(this.repository);

  Future<Either<Failure, List<Comment>>> call(String videoId) async {
    return await repository.getVideoComments(videoId);
  }
}
