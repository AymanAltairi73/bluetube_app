import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/video_repository.dart';

/// Use case for unsubscribing from a channel
class UnsubscribeFromChannel {
  final VideoRepository repository;

  UnsubscribeFromChannel(this.repository);

  Future<Either<Failure, bool>> call(String channelId) async {
    return await repository.unsubscribeFromChannel(channelId);
  }
}
