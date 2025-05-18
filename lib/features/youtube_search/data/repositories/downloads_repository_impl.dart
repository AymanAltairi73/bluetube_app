import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/downloaded_video.dart';
import '../../domain/entities/youtube_video.dart';
import '../../domain/repositories/downloads_repository.dart';
import '../datasources/downloads_local_data_source.dart';

/// Implementation of [DownloadsRepository]
class DownloadsRepositoryImpl implements DownloadsRepository {
  final DownloadsLocalDataSource localDataSource;

  /// Constructor
  DownloadsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<DownloadedVideo>>> getDownloadedVideos() async {
    try {
      final videos = await localDataSource.getDownloadedVideos();
      return Right(videos);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DownloadedVideo>> downloadVideo(
    YouTubeVideo video, {
    String quality = '720p',
  }) async {
    try {
      final result = await localDataSource.downloadVideo(
        video,
        quality: quality,
      );
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteDownloadedVideo(String videoId) async {
    try {
      final result = await localDataSource.deleteDownloadedVideo(videoId);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isVideoDownloaded(String videoId) async {
    try {
      final result = await localDataSource.isVideoDownloaded(videoId);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, DownloadedVideo?>> getDownloadedVideo(String videoId) async {
    try {
      final result = await localDataSource.getDownloadedVideo(videoId);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, int>> getTotalDownloadSize() async {
    try {
      final result = await localDataSource.getTotalDownloadSize();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
