import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/downloaded_video.dart';
import '../repositories/downloads_repository.dart';

/// Use case for getting downloaded videos
class GetDownloadedVideos implements UseCase<List<DownloadedVideo>, NoParams> {
  final DownloadsRepository repository;

  /// Constructor
  GetDownloadedVideos(this.repository);

  @override
  Future<Either<Failure, List<DownloadedVideo>>> call(NoParams params) async {
    return await repository.getDownloadedVideos();
  }
}
