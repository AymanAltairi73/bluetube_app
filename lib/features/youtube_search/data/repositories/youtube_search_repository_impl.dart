import 'package:dartz/dartz.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/youtube_video.dart';
import '../../domain/repositories/youtube_search_repository.dart';
import '../datasources/youtube_api_data_source.dart';

/// Implementation of [YouTubeSearchRepository]
class YouTubeSearchRepositoryImpl implements YouTubeSearchRepository {
  final YouTubeApiDataSource dataSource;
  
  String? _nextPageToken;
  String? _prevPageToken;
  int _totalResults = 0;

  YouTubeSearchRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<YouTubeVideo>>> searchVideos(
    String query, {
    String? pageToken,
    int maxResults = ApiConfig.defaultMaxResults,
  }) async {
    try {
      final response = await dataSource.searchVideos(
        query,
        pageToken: pageToken,
        maxResults: maxResults,
      );
      
      // Store pagination info
      _nextPageToken = response.nextPageToken;
      _prevPageToken = response.prevPageToken;
      _totalResults = response.totalResults;
      
      // Convert models to entities
      final videos = response.videos.map((model) => model.toEntity()).toList();
      
      return Right(videos);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, YouTubeVideo>> getVideoDetails(String videoId) async {
    try {
      final response = await dataSource.getVideoDetails(videoId);
      return Right(response.video.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
  
  @override
  String? getNextPageToken() => _nextPageToken;
  
  @override
  String? getPrevPageToken() => _prevPageToken;
  
  @override
  int getTotalResults() => _totalResults;
}
