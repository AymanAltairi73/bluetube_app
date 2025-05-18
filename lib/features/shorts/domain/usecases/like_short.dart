import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/shorts_repository.dart';

/// Use case for liking a short
class LikeShort {
  final ShortsRepository repository;

  LikeShort(this.repository);

  Future<Either<Failure, bool>> call(String shortId) async {
    return await repository.likeShort(shortId);
  }
}
