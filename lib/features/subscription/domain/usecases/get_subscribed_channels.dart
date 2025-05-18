import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/channel.dart';
import '../repositories/subscription_repository.dart';

/// Use case for getting all subscribed channels
class GetSubscribedChannels {
  final SubscriptionRepository repository;

  GetSubscribedChannels(this.repository);

  Future<Either<Failure, List<Channel>>> call() async {
    return await repository.getSubscribedChannels();
  }
}
