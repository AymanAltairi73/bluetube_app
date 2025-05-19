import 'package:dartz/dartz.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/youtube_video.dart';
import '../repositories/youtube_search_repository.dart';

/// Parameters for [GetVideosByCategory] use case
class GetVideosByCategoryParams {
  /// Category ID
  final String categoryId;
  
  /// Maximum results per page
  final int maxResults;
  
  /// Page token for pagination
  final String? pageToken;

  /// Constructor
  const GetVideosByCategoryParams({
    required this.categoryId,
    this.maxResults = ApiConfig.defaultMaxResults,
    this.pageToken,
  });
}

/// Use case to get videos by category
class GetVideosByCategory implements UseCase<List<YouTubeVideo>, GetVideosByCategoryParams> {
  final YouTubeSearchRepository repository;

  /// Constructor
  GetVideosByCategory(this.repository);

  @override
  Future<Either<Failure, List<YouTubeVideo>>> call(GetVideosByCategoryParams params) {
    return repository.getVideosByCategory(
      params.categoryId,
      maxResults: params.maxResults,
      pageToken: params.pageToken,
    );
  }
}
