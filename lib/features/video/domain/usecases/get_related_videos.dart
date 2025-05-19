import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/related_video.dart';
import '../repositories/video_repository.dart';

/// Parameters for [GetRelatedVideos] use case
class GetRelatedVideosParams {
  /// Video ID
  final String videoId;

  /// Constructor
  const GetRelatedVideosParams({
    required this.videoId,
  });
}

/// Use case for getting related videos for a video
class GetRelatedVideos implements UseCase<List<RelatedVideo>, GetRelatedVideosParams> {
  final VideoRepository repository;

  /// Constructor
  GetRelatedVideos(this.repository);

  @override
  Future<Either<Failure, List<RelatedVideo>>> call(GetRelatedVideosParams params) async {
    return await repository.getRelatedVideos(params.videoId);
  }
}
