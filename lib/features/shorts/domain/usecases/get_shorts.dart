import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/short.dart';
import '../repositories/shorts_repository.dart';

/// Use case for getting all shorts
class GetShorts {
  final ShortsRepository repository;

  GetShorts(this.repository);

  Future<Either<Failure, List<Short>>> call() async {
    return await repository.getShorts();
  }
}
