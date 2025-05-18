import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_repository.dart';

/// Use case for unliking a comment
class UnlikeComment {
  final VideoRepository repository;

  UnlikeComment(this.repository);

  Future<Either<Failure, bool>> call(String commentId) async {
    return await repository.unlikeComment(commentId);
  }
}
