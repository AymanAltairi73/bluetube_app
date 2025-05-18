import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/video.dart';
import '../repositories/home_repository.dart';

/// Use case for getting videos by category
class GetVideosByCategory {
  final HomeRepository repository;

  GetVideosByCategory(this.repository);

  Future<Either<Failure, List<Video>>> call(String category) async {
    return await repository.getVideosByCategory(category);
  }
}
