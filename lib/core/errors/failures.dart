/// Base failure class for the application
abstract class Failure {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});
}

/// Server failures (API, backend issues)
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Network failures (connectivity issues)
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network connection failed'});
}

/// Cache failures (local storage issues)
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache operation failed'});
}

/// Input validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

/// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

/// Unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'An unexpected error occurred'});
}
