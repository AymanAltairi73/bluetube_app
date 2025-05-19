import 'package:dartz/dartz.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/youtube_video.dart';
import '../repositories/youtube_search_repository.dart';

/// Parameters for [GetTrendingVideos] use case
class GetTrendingVideosParams {
  /// Region code
  final String regionCode;
  
  /// Category ID
  final String? categoryId;
  
  /// Maximum results per page
  final int maxResults;
  
  /// Page token for pagination
  final String? pageToken;

  /// Constructor
  const GetTrendingVideosParams({
    this.regionCode = ApiConfig.defaultRegionCode,
    this.categoryId,
    this.maxResults = ApiConfig.defaultMaxResults,
    this.pageToken,
  });
}

/// Use case to get trending videos
class GetTrendingVideos implements UseCase<List<YouTubeVideo>, GetTrendingVideosParams> {
  final YouTubeSearchRepository repository;

  /// Constructor
  GetTrendingVideos(this.repository);

  @override
  Future<Either<Failure, List<YouTubeVideo>>> call(GetTrendingVideosParams params) {
    return repository.getTrendingVideos(
      regionCode: params.regionCode,
      categoryId: params.categoryId,
      maxResults: params.maxResults,
      pageToken: params.pageToken,
    );
  }
}
