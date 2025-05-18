import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/video.dart';
import '../repositories/home_repository.dart';

/// Use case for getting all videos for the home feed
class GetVideos {
  final HomeRepository repository;

  GetVideos(this.repository);

  Future<Either<Failure, List<Video>>> call() async {
    return await repository.getVideos();
  }
}
