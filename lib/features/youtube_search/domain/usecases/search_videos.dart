import 'package:dartz/dartz.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/youtube_video.dart';
import '../repositories/youtube_search_repository.dart';

/// Parameters for [SearchVideos] use case
class SearchVideosParams {
  /// Search query
  final String query;

  /// Page token for pagination
  final String? pageToken;

  /// Maximum results per page
  final int maxResults;

  /// Constructor
  const SearchVideosParams({
    required this.query,
    this.pageToken,
    this.maxResults = ApiConfig.defaultMaxResults,
  });
}

/// Use case for searching YouTube videos
class SearchVideos implements UseCase<List<YouTubeVideo>, SearchVideosParams> {
  final YouTubeSearchRepository repository;

  /// Constructor
  SearchVideos(this.repository);

  @override
  Future<Either<Failure, List<YouTubeVideo>>> call(SearchVideosParams params) async {
    return await repository.searchVideos(
      params.query,
      pageToken: params.pageToken,
      maxResults: params.maxResults,
    );
  }
}
