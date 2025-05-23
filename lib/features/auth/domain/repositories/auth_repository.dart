import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_response_entity.dart';
import '../entities/user_entity.dart';

/// Repository interface for authentication-related operations
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, AuthResponseEntity>> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<Either<Failure, AuthResponseEntity>> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Login with Google
  Future<Either<Failure, AuthResponseEntity>> loginWithGoogle();

  /// Login with Facebook
  Future<Either<Failure, AuthResponseEntity>> loginWithFacebook();



  /// Logout the current user
  Future<Either<Failure, bool>> logout();

  /// Send password reset email
  Future<Either<Failure, bool>> forgotPassword(String email);

  /// Check if user is logged in
  Future<Either<Failure, bool>> isLoggedIn();

  /// Get current user
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Refresh authentication token
  Future<Either<Failure, AuthResponseEntity>> refreshToken(String refreshToken);
}
