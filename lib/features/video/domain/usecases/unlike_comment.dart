import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/video_repository.dart';

/// Parameters for [UnlikeComment] use case
class UnlikeCommentParams {
  /// Comment ID
  final String commentId;

  /// Constructor
  const UnlikeCommentParams({
    required this.commentId,
  });
}

/// Use case for unliking a comment
class UnlikeComment implements UseCase<bool, UnlikeCommentParams> {
  final VideoRepository repository;

  /// Constructor
  UnlikeComment(this.repository);

  @override
  Future<Either<Failure, bool>> call(UnlikeCommentParams params) async {
    return await repository.unlikeComment(params.commentId);
  }
}
