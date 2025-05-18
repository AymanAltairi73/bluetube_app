import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_repository.dart';

/// Use case for liking a comment
class LikeComment {
  final VideoRepository repository;

  LikeComment(this.repository);

  Future<Either<Failure, bool>> call(String commentId) async {
    return await repository.likeComment(commentId);
  }
}
