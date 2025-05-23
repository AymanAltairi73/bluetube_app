import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case for checking if a user is logged in
class IsLoggedInUseCase {
  final AuthRepository repository;

  IsLoggedInUseCase(this.repository);

  /// Execute the is logged in use case
  Future<Either<Failure, bool>> call() async {
    return await repository.isLoggedIn();
  }
}
