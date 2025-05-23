import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case for requesting a password reset
class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  /// Execute the forgot password use case
  Future<Either<Failure, bool>> call(String email) async {
    return await repository.forgotPassword(email);
  }
}
