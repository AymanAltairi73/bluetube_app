import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_response_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for social login (Google, Facebook)
class SocialLoginUseCase {
  final AuthRepository repository;

  SocialLoginUseCase(this.repository);

  /// Login with Google
  Future<Either<Failure, AuthResponseEntity>> loginWithGoogle() async {
    return await repository.loginWithGoogle();
  }

  /// Login with Facebook
  Future<Either<Failure, AuthResponseEntity>> loginWithFacebook() async {
    return await repository.loginWithFacebook();
  }


}
