import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/comment.dart';
import '../repositories/video_repository.dart';

/// Use case for adding a comment to a video
class AddComment {
  final VideoRepository repository;

  AddComment(this.repository);

  Future<Either<Failure, Comment>> call(String videoId, String text) async {
    return await repository.addComment(videoId, text);
  }
}
