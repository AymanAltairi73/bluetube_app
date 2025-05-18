import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/video_detail.dart';
import '../repositories/video_repository.dart';

/// Use case for getting video details by ID
class GetVideoDetail {
  final VideoRepository repository;

  GetVideoDetail(this.repository);

  Future<Either<Failure, VideoDetail>> call(String videoId) async {
    return await repository.getVideoDetail(videoId);
  }
}
