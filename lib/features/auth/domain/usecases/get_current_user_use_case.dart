import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting the current user
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  /// Execute the get current user use case
  Future<Either<Failure, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}
