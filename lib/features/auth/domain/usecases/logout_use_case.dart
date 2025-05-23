import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case for logging out
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// Execute the logout use case
  Future<Either<Failure, bool>> call() async {
    return await repository.logout();
  }
}
