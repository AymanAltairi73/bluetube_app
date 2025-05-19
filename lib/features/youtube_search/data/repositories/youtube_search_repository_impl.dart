import 'package:dartz/dartz.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/youtube_channel.dart';
import '../../domain/entities/youtube_comment.dart';
import '../../domain/entities/youtube_video.dart';
import '../../domain/repositories/youtube_search_repository.dart';
import '../datasources/youtube_api_data_source.dart';
import '../models/youtube_channel_model.dart';
import '../models/youtube_comment_model.dart';

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

  @override
  Future<Either<Failure, YouTubeChannel>> getChannelDetails(String channelId) async {
    try {
      // In a real implementation, this would call the API data source
      // For now, we'll implement a simple version that works with our mock data
      final jsonData = await dataSource.getChannelDetails(channelId);

      // Parse the JSON data into a channel model
      final channelModel = YouTubeChannelModel.fromJson(jsonData['items'][0]);

      // Convert to entity
      return Right(channelModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<YouTubeVideo>>> getTrendingVideos({
    String regionCode = 'US',
    String? categoryId,
    int maxResults = ApiConfig.defaultMaxResults,
    String? pageToken,
  }) async {
    try {
      // In a real implementation, this would call the API data source
      // For now, we'll implement a simple version that works with our mock data
      final response = await dataSource.getTrendingVideos();

      // Convert models to entities
      final videos = response.video.toEntity();

      // In a real implementation, this would return a list of videos
      // For now, we'll return a list with just one video
      return Right([videos]);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<YouTubeVideo>>> getVideosByCategory(
    String categoryId, {
    int maxResults = ApiConfig.defaultMaxResults,
    String? pageToken,
  }) async {
    try {
      // In a real implementation, this would call the API data source
      // For now, we'll implement a simple version that works with our mock data
      final response = await dataSource.getVideosByCategory(categoryId);

      // Convert models to entities
      final videos = response.video.toEntity();

      // In a real implementation, this would return a list of videos
      // For now, we'll return a list with just one video
      return Right([videos]);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<YouTubeComment>>> getVideoComments(
    String videoId, {
    int maxResults = ApiConfig.defaultMaxResults,
    String? pageToken,
  }) async {
    try {
      // In a real implementation, this would call the API data source
      // For now, we'll implement a simple version that works with our mock data
      final jsonData = await dataSource.getVideoComments(videoId);

      // Parse the JSON data into comment models
      final items = jsonData['items'] as List;
      final comments = items.map((item) =>
        YouTubeCommentModel.fromJson(item)).toList();

      // Convert to entities
      return Right(comments.map((model) => model).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<YouTubeVideo>>> getRelatedVideos(
    String videoId, {
    int maxResults = ApiConfig.defaultMaxResults,
    String? pageToken,
  }) async {
    try {
      // In a real implementation, this would call the API data source
      // For now, we'll implement a simple version that works with our mock data
      final response = await dataSource.getRelatedVideos(videoId);

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
}
