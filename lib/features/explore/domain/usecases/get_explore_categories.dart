import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/explore_category.dart';
import '../repositories/explore_repository.dart';

/// Use case for getting all explore categories
class GetExploreCategories {
  final ExploreRepository repository;

  GetExploreCategories(this.repository);

  Future<Either<Failure, List<ExploreCategory>>> call() async {
    return await repository.getExploreCategories();
  }
}
