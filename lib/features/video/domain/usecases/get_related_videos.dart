import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/related_video.dart';
import '../repositories/video_repository.dart';

/// Use case for getting related videos for a video
class GetRelatedVideos {
  final VideoRepository repository;

  GetRelatedVideos(this.repository);

  Future<Either<Failure, List<RelatedVideo>>> call(String videoId) async {
    return await repository.getRelatedVideos(videoId);
  }
}
