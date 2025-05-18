import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/video.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';

/// Implementation of [HomeRepository]
class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Video>>> getVideos() async {
    try {
      final videos = await localDataSource.getVideos();
      return Right(videos);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Video>>> getVideosByCategory(String category) async {
    try {
      final videos = await localDataSource.getVideosByCategory(category);
      return Right(videos);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await localDataSource.getCategories();
      return Right(categories);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Video>>> getTrendingVideos() async {
    try {
      final videos = await localDataSource.getTrendingVideos();
      return Right(videos);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Video>>> getRecommendedVideos() async {
    try {
      final videos = await localDataSource.getRecommendedVideos();
      return Right(videos);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }
}
