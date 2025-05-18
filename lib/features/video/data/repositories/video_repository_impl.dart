import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/video_detail.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/related_video.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/video_local_data_source.dart';

/// Implementation of [VideoRepository]
class VideoRepositoryImpl implements VideoRepository {
  final VideoLocalDataSource localDataSource;

  VideoRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, VideoDetail>> getVideoDetail(String videoId) async {
    try {
      final videoDetail = await localDataSource.getVideoDetail(videoId);
      return Right(videoDetail);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getVideoComments(String videoId) async {
    try {
      final comments = await localDataSource.getVideoComments(videoId);
      return Right(comments);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<RelatedVideo>>> getRelatedVideos(String videoId) async {
    try {
      final relatedVideos = await localDataSource.getRelatedVideos(videoId);
      return Right(relatedVideos);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> likeVideo(String videoId) async {
    try {
      final result = await localDataSource.likeVideo(videoId);
      return Right(result);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> dislikeVideo(String videoId) async {
    try {
      final result = await localDataSource.dislikeVideo(videoId);
      return Right(result);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> removeLikeDislike(String videoId) async {
    try {
      final result = await localDataSource.removeLikeDislike(videoId);
      return Right(result);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> subscribeToChannel(String channelId) async {
    try {
      final result = await localDataSource.subscribeToChannel(channelId);
      return Right(result);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> unsubscribeFromChannel(String channelId) async {
    try {
      final result = await localDataSource.unsubscribeFromChannel(channelId);
      return Right(result);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment(String videoId, String text) async {
    try {
      final comment = await localDataSource.addComment(videoId, text);
      return Right(comment);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> likeComment(String commentId) async {
    try {
      final result = await localDataSource.likeComment(commentId);
      return Right(result);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> unlikeComment(String commentId) async {
    try {
      final result = await localDataSource.unlikeComment(commentId);
      return Right(result);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }
}
