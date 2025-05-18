import 'package:dartz/dartz.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import '../entities/youtube_video.dart';
import '../repositories/youtube_search_repository.dart';

/// Use case for searching YouTube videos
class SearchVideos {
  final YouTubeSearchRepository repository;

  SearchVideos(this.repository);

  /// Search for videos by query
  Future<Either<Failure, List<YouTubeVideo>>> call(
    String query, {
    String? pageToken,
    int maxResults = ApiConfig.defaultMaxResults,
  }) async {
    return await repository.searchVideos(
      query,
      pageToken: pageToken,
      maxResults: maxResults,
    );
  }
}
