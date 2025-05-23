import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_response_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing up a new user
class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  /// Execute the signup use case
  Future<Either<Failure, AuthResponseEntity>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await repository.signup(
      name: name,
      email: email,
      password: password,
    );
  }
}
