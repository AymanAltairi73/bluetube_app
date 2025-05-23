import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_response_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_service.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Implementation of [AuthRepository]
class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.authService,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthResponseEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Use Firebase Auth service to sign in
      final user = await authService.signInWithEmail(email, password);

      if (user == null) {
        return Left(ServerFailure(message: 'Failed to sign in'));
      }

      // Create auth response model
      final userModel = UserModel(
        id: user.uid,
        name: user.displayName ?? email.split('@')[0],
        email: user.email ?? email,
        photoUrl: user.photoURL,
        isEmailVerified: user.emailVerified,
        createdAt: DateTime.now(),
      );

      final authResponse = AuthResponseModel(
        user: userModel,
        accessToken: await user.getIdToken() ?? '',
        refreshToken: user.refreshToken ?? '',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      // Save auth response locally
      await localDataSource.saveAuthResponse(authResponse);

      return Right(authResponse);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Use Firebase Auth service to register
      final user = await authService.registerWithEmail(email, password);

      if (user == null) {
        return Left(ServerFailure(message: 'Failed to register'));
      }

      // Update user profile with name
      await authService.updateProfile(displayName: name);

      // Create auth response model
      final userModel = UserModel(
        id: user.uid,
        name: name,
        email: user.email ?? email,
        photoUrl: user.photoURL,
        isEmailVerified: user.emailVerified,
        createdAt: DateTime.now(),
      );

      final authResponse = AuthResponseModel(
        user: userModel,
        accessToken: await user.getIdToken() ?? '',
        refreshToken: user.refreshToken ?? '',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      // Save auth response locally
      await localDataSource.saveAuthResponse(authResponse);

      return Right(authResponse);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> loginWithGoogle() async {
    try {
      // Use Firebase Auth service to sign in with Google
      final user = await authService.signInWithGoogle();

      if (user == null) {
        return Left(ServerFailure(message: 'Failed to sign in with Google'));
      }

      // Create auth response model
      final userModel = UserModel(
        id: user.uid,
        name: user.displayName ?? user.email?.split('@')[0] ?? 'Google User',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        isEmailVerified: user.emailVerified,
        createdAt: DateTime.now(),
      );

      final authResponse = AuthResponseModel(
        user: userModel,
        accessToken: await user.getIdToken() ?? '',
        refreshToken: user.refreshToken ?? '',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      // Save auth response locally
      await localDataSource.saveAuthResponse(authResponse);

      return Right(authResponse);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> loginWithFacebook() async {
    // Facebook login is not implemented as per requirements
    return Left(ServerFailure(message: 'Facebook login is not implemented'));
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      // Sign out from Firebase Auth
      await authService.signOut();

      // Clear local data
      final result = await localDataSource.clearAuthData();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    try {
      // Send password reset email
      await authService.sendPasswordResetEmail(email);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      // Check if user is signed in with Firebase Auth
      final isSignedIn = authService.isSignedIn;

      if (!isSignedIn) {
        return const Right(false);
      }

      // Double-check with local storage
      final result = await localDataSource.isLoggedIn();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      // Get current user from Firebase Auth
      final firebaseUser = authService.currentUser;

      if (firebaseUser == null) {
        // Try to get from local storage as fallback
        final user = await localDataSource.getCurrentUser();
        return Right(user);
      }

      // Create user model from Firebase user
      final userModel = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? firebaseUser.email?.split('@')[0] ?? 'User',
        email: firebaseUser.email ?? '',
        photoUrl: firebaseUser.photoURL,
        isEmailVerified: firebaseUser.emailVerified,
        createdAt: DateTime.now(), // We don't have creation time from Firebase Auth
      );

      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> refreshToken(String refreshToken) async {
    try {
      // Get current user from Firebase Auth
      final user = authService.currentUser;

      if (user == null) {
        return Left(ServerFailure(message: 'User not authenticated'));
      }

      // Get fresh token
      final token = await user.getIdToken(true);

      if (token == null) {
        return Left(ServerFailure(message: 'Failed to refresh token'));
      }

      // Create user model
      final userModel = UserModel(
        id: user.uid,
        name: user.displayName ?? user.email?.split('@')[0] ?? 'User',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        isEmailVerified: user.emailVerified,
        createdAt: DateTime.now(),
      );

      // Create auth response
      final authResponse = AuthResponseModel(
        user: userModel,
        accessToken: token,
        refreshToken: user.refreshToken ?? '',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      // Save to local storage
      await localDataSource.saveAuthResponse(authResponse);

      return Right(authResponse);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
