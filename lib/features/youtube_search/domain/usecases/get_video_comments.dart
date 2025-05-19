import 'package:dartz/dartz.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/youtube_comment.dart';
import '../repositories/youtube_search_repository.dart';

/// Parameters for [GetVideoComments] use case
class GetVideoCommentsParams {
  /// Video ID
  final String videoId;
  
  /// Maximum results per page
  final int maxResults;
  
  /// Page token for pagination
  final String? pageToken;

  /// Constructor
  const GetVideoCommentsParams({
    required this.videoId,
    this.maxResults = ApiConfig.defaultMaxResults,
    this.pageToken,
  });
}

/// Use case to get video comments
class GetVideoComments implements UseCase<List<YouTubeComment>, GetVideoCommentsParams> {
  final YouTubeSearchRepository repository;

  /// Constructor
  GetVideoComments(this.repository);

  @override
  Future<Either<Failure, List<YouTubeComment>>> call(GetVideoCommentsParams params) {
    return repository.getVideoComments(
      params.videoId,
      maxResults: params.maxResults,
      pageToken: params.pageToken,
    );
  }
}
