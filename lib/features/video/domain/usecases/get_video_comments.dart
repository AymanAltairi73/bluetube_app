import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comment.dart';
import '../repositories/video_repository.dart';

/// Parameters for [GetVideoComments] use case
class GetVideoCommentsParams {
  /// Video ID
  final String videoId;

  /// Constructor
  const GetVideoCommentsParams({
    required this.videoId,
  });
}

/// Use case for getting comments for a video
class GetVideoComments implements UseCase<List<Comment>, GetVideoCommentsParams> {
  final VideoRepository repository;

  /// Constructor
  GetVideoComments(this.repository);

  @override
  Future<Either<Failure, List<Comment>>> call(GetVideoCommentsParams params) async {
    return await repository.getVideoComments(params.videoId);
  }
}
