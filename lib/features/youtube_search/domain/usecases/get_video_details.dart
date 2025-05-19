import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/youtube_video.dart';
import '../repositories/youtube_search_repository.dart';

/// Parameters for [GetYouTubeVideoDetails] use case
class GetVideoDetailsParams {
  /// Video ID
  final String videoId;

  /// Constructor
  const GetVideoDetailsParams({
    required this.videoId,
  });
}

/// Use case for getting YouTube video details
class GetYouTubeVideoDetails implements UseCase<YouTubeVideo, GetVideoDetailsParams> {
  final YouTubeSearchRepository repository;

  /// Constructor
  GetYouTubeVideoDetails(this.repository);

  @override
  Future<Either<Failure, YouTubeVideo>> call(GetVideoDetailsParams params) async {
    return await repository.getVideoDetails(params.videoId);
  }
}
