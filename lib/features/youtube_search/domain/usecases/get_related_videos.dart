import 'package:dartz/dartz.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/youtube_video.dart';
import '../repositories/youtube_search_repository.dart';

/// Parameters for [GetRelatedVideos] use case
class GetRelatedVideosParams {
  /// Video ID
  final String videoId;
  
  /// Maximum results per page
  final int maxResults;
  
  /// Page token for pagination
  final String? pageToken;

  /// Constructor
  const GetRelatedVideosParams({
    required this.videoId,
    this.maxResults = ApiConfig.defaultMaxResults,
    this.pageToken,
  });
}

/// Use case to get related videos
class GetRelatedVideos implements UseCase<List<YouTubeVideo>, GetRelatedVideosParams> {
  final YouTubeSearchRepository repository;

  /// Constructor
  GetRelatedVideos(this.repository);

  @override
  Future<Either<Failure, List<YouTubeVideo>>> call(GetRelatedVideosParams params) {
    return repository.getRelatedVideos(
      params.videoId,
      maxResults: params.maxResults,
      pageToken: params.pageToken,
    );
  }
}
