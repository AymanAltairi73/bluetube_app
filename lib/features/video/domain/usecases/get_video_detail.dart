import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/video_detail.dart';
import '../repositories/video_repository.dart';

/// Parameters for [GetVideoDetail] use case
class GetVideoDetailParams {
  /// Video ID
  final String videoId;

  /// Constructor
  const GetVideoDetailParams({
    required this.videoId,
  });
}

/// Use case for getting video details by ID
class GetVideoDetail implements UseCase<VideoDetail, GetVideoDetailParams> {
  final VideoRepository repository;

  /// Constructor
  GetVideoDetail(this.repository);

  @override
  Future<Either<Failure, VideoDetail>> call(GetVideoDetailParams params) async {
    return await repository.getVideoDetail(params.videoId);
  }
}
