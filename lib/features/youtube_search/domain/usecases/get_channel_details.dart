import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/youtube_channel.dart';
import '../repositories/youtube_search_repository.dart';

/// Parameters for [GetChannelDetails] use case
class GetChannelDetailsParams {
  /// Channel ID
  final String channelId;

  /// Constructor
  const GetChannelDetailsParams({
    required this.channelId,
  });
}

/// Use case to get channel details
class GetChannelDetails implements UseCase<YouTubeChannel, GetChannelDetailsParams> {
  final YouTubeSearchRepository repository;

  /// Constructor
  GetChannelDetails(this.repository);

  @override
  Future<Either<Failure, YouTubeChannel>> call(GetChannelDetailsParams params) {
    return repository.getChannelDetails(params.channelId);
  }
}
