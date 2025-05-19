import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comment.dart';
import '../repositories/video_repository.dart';

/// Parameters for [AddComment] use case
class AddCommentParams {
  /// Video ID
  final String videoId;

  /// Comment text
  final String text;

  /// Constructor
  const AddCommentParams({
    required this.videoId,
    required this.text,
  });
}

/// Use case for adding a comment to a video
class AddComment implements UseCase<Comment, AddCommentParams> {
  final VideoRepository repository;

  /// Constructor
  AddComment(this.repository);

  @override
  Future<Either<Failure, Comment>> call(AddCommentParams params) async {
    return await repository.addComment(params.videoId, params.text);
  }
}
