import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/explore_video.dart';
import '../repositories/explore_repository.dart';

/// Use case for getting videos by category
class GetVideosByCategory {
  final ExploreRepository repository;

  GetVideosByCategory(this.repository);

  Future<Either<Failure, List<ExploreVideo>>> call(String categoryId) async {
    return await repository.getVideosByCategory(categoryId);
  }
}
