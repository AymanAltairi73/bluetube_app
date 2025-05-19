import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/video_repository.dart';

/// Parameters for [SubscribeToChannel] use case
class SubscribeToChannelParams {
  /// Channel ID
  final String channelId;

  /// Constructor
  const SubscribeToChannelParams({
    required this.channelId,
  });
}

/// Use case for subscribing to a channel
class SubscribeToChannel implements UseCase<bool, SubscribeToChannelParams> {
  final VideoRepository repository;

  /// Constructor
  SubscribeToChannel(this.repository);

  @override
  Future<Either<Failure, bool>> call(SubscribeToChannelParams params) async {
    return await repository.subscribeToChannel(params.channelId);
  }
}
