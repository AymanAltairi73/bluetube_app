import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_response_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for logging in with email and password
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Execute the login use case
  Future<Either<Failure, AuthResponseEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(
      email: email,
      password: password,
    );
  }
}
