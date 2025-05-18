import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/saved_video.dart';
import '../../domain/repositories/watch_later_repository.dart';
import '../datasources/watch_later_local_data_source.dart';

/// Implementation of [WatchLaterRepository]
class WatchLaterRepositoryImpl implements WatchLaterRepository {
  final WatchLaterLocalDataSource localDataSource;

  /// Constructor
  WatchLaterRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SavedVideo>>> getSavedVideos() async {
    try {
      final videos = await localDataSource.getSavedVideos();
      return Right(videos);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveVideo(SavedVideo video) async {
    try {
      final result = await localDataSource.saveVideo(video);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeVideo(String videoId) async {
    try {
      final result = await localDataSource.removeVideo(videoId);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isVideoSaved(String videoId) async {
    try {
      final result = await localDataSource.isVideoSaved(videoId);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
