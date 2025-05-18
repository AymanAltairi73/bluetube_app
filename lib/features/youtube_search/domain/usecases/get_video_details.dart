import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/youtube_video.dart';
import '../repositories/youtube_search_repository.dart';

/// Use case for getting YouTube video details
class GetYouTubeVideoDetails {
  final YouTubeSearchRepository repository;

  GetYouTubeVideoDetails(this.repository);

  /// Get video details by ID
  Future<Either<Failure, YouTubeVideo>> call(String videoId) async {
    return await repository.getVideoDetails(videoId);
  }
}
