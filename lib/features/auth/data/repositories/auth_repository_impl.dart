import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_response_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

/// Implementation of [AuthRepository]
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthResponseEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save auth response locally
      await localDataSource.saveAuthResponse(authResponse);

      return Right(authResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await remoteDataSource.signup(
        name: name,
        email: email,
        password: password,
      );

      // Save auth response locally
      await localDataSource.saveAuthResponse(authResponse);

      return Right(authResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> loginWithGoogle() async {
    try {
      final authResponse = await remoteDataSource.loginWithGoogle();

      // Save auth response locally
      await localDataSource.saveAuthResponse(authResponse);

      return Right(authResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> loginWithFacebook() async {
    try {
      final authResponse = await remoteDataSource.loginWithFacebook();

      // Save auth response locally
      await localDataSource.saveAuthResponse(authResponse);

      return Right(authResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }



  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await localDataSource.clearAuthData();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    try {
      final result = await remoteDataSource.forgotPassword(email);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final result = await localDataSource.isLoggedIn();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCurrentUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> refreshToken(String refreshToken) async {
    try {
      final authResponse = await remoteDataSource.refreshToken(refreshToken);

      // Save auth response locally
      await localDataSource.saveAuthResponse(authResponse);

      return Right(authResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
