import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/video_repository.dart';

/// Parameters for [UnsubscribeFromChannel] use case
class UnsubscribeFromChannelParams {
  /// Channel ID
  final String channelId;

  /// Constructor
  const UnsubscribeFromChannelParams({
    required this.channelId,
  });
}

/// Use case for unsubscribing from a channel
class UnsubscribeFromChannel implements UseCase<bool, UnsubscribeFromChannelParams> {
  final VideoRepository repository;

  /// Constructor
  UnsubscribeFromChannel(this.repository);

  @override
  Future<Either<Failure, bool>> call(UnsubscribeFromChannelParams params) async {
    return await repository.unsubscribeFromChannel(params.channelId);
  }
}
