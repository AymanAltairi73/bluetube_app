import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/video_repository.dart';

/// Parameters for [LikeComment] use case
class LikeCommentParams {
  /// Comment ID
  final String commentId;

  /// Constructor
  const LikeCommentParams({
    required this.commentId,
  });
}

/// Use case for liking a comment
class LikeComment implements UseCase<bool, LikeCommentParams> {
  final VideoRepository repository;

  /// Constructor
  LikeComment(this.repository);

  @override
  Future<Either<Failure, bool>> call(LikeCommentParams params) async {
    return await repository.likeComment(params.commentId);
  }
}
