import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/explore_category.dart';
import '../../domain/entities/explore_video.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_local_data_source.dart';

/// Implementation of [ExploreRepository]
class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreLocalDataSource localDataSource;

  ExploreRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ExploreCategory>>> getExploreCategories() async {
    try {
      final categories = await localDataSource.getExploreCategories();
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
  Future<Either<Failure, List<ExploreVideo>>> getTrendingVideos() async {
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
  Future<Either<Failure, List<ExploreVideo>>> getVideosByCategory(String categoryId) async {
    try {
      final videos = await localDataSource.getVideosByCategory(categoryId);
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
