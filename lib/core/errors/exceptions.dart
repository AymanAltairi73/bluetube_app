/// Base exception class
class AppException implements Exception {
  final String message;

  AppException({required this.message});

  @override
  String toString() => message;
}

/// Exception for server errors
class ServerException extends AppException {
  ServerException({required super.message});
}

/// Exception for cache errors
class CacheException extends AppException {
  CacheException({required super.message});
}

/// Exception for network errors
class NetworkException extends AppException {
  NetworkException({required super.message});
}

/// Exception for authentication errors
class AuthException extends AppException {
  AuthException({required super.message});
}

/// Exception for validation errors
class ValidationException extends AppException {
  ValidationException({required super.message});
}
