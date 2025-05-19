import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base UseCase interface for all use cases
abstract class UseCase<Type, Params> {
  /// Call method to execute the use case
  Future<Either<Failure, Type>> call(Params params);
}

/// No parameters class for use cases that don't require parameters
class NoParams {
  const NoParams();
}
