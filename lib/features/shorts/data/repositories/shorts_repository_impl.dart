import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/short.dart';
import '../../domain/repositories/shorts_repository.dart';
import '../datasources/shorts_local_data_source.dart';

/// Implementation of [ShortsRepository]
class ShortsRepositoryImpl implements ShortsRepository {
  final ShortsLocalDataSource localDataSource;

  ShortsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Short>>> getShorts() async {
    try {
      final shorts = await localDataSource.getShorts();
      return Right(shorts);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Short>>> getShortsByAuthor(String author) async {
    try {
      final shorts = await localDataSource.getShortsByAuthor(author);
      return Right(shorts);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> likeShort(String shortId) async {
    try {
      final result = await localDataSource.likeShort(shortId);
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
  Future<Either<Failure, bool>> unlikeShort(String shortId) async {
    try {
      final result = await localDataSource.unlikeShort(shortId);
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
  Future<Either<Failure, bool>> subscribeToAuthor(String author) async {
    try {
      final result = await localDataSource.subscribeToAuthor(author);
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
  Future<Either<Failure, bool>> unsubscribeFromAuthor(String author) async {
    try {
      final result = await localDataSource.unsubscribeFromAuthor(author);
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
