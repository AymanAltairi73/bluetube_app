import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/explore_video.dart';
import '../repositories/explore_repository.dart';

/// Use case for getting trending videos
class GetTrendingVideos {
  final ExploreRepository repository;

  GetTrendingVideos(this.repository);

  Future<Either<Failure, List<ExploreVideo>>> call() async {
    return await repository.getTrendingVideos();
  }
}
