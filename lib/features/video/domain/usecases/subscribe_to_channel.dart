import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_repository.dart';

/// Use case for subscribing to a channel
class SubscribeToChannel {
  final VideoRepository repository;

  SubscribeToChannel(this.repository);

  Future<Either<Failure, bool>> call(String channelId) async {
    return await repository.subscribeToChannel(channelId);
  }
}
