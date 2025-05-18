import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/shorts_repository.dart';

/// Use case for subscribing to an author
class SubscribeToAuthor {
  final ShortsRepository repository;

  SubscribeToAuthor(this.repository);

  Future<Either<Failure, bool>> call(String author) async {
    return await repository.subscribeToAuthor(author);
  }
}
