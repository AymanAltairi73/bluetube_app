import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/channel.dart';
import '../../domain/entities/subscription_video.dart';
import '../../domain/entities/subscription_filter.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_local_data_source.dart';

/// Implementation of [SubscriptionRepository]
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionLocalDataSource localDataSource;

  SubscriptionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Channel>>> getSubscribedChannels() async {
    try {
      final channels = await localDataSource.getSubscribedChannels();
      return Right(channels);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<SubscriptionVideo>>> getSubscriptionVideos() async {
    try {
      final videos = await localDataSource.getSubscriptionVideos();
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
  Future<Either<Failure, List<SubscriptionVideo>>> getFilteredSubscriptionVideos(String filter) async {
    try {
      final videos = await localDataSource.getFilteredSubscriptionVideos(filter);
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
  Future<Either<Failure, List<SubscriptionFilter>>> getSubscriptionFilters() async {
    try {
      final filters = await localDataSource.getSubscriptionFilters();
      return Right(filters);
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
}
