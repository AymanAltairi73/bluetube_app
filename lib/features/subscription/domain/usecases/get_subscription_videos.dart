import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/subscription_video.dart';
import '../repositories/subscription_repository.dart';

/// Use case for getting videos from subscribed channels
class GetSubscriptionVideos {
  final SubscriptionRepository repository;

  GetSubscriptionVideos(this.repository);

  Future<Either<Failure, List<SubscriptionVideo>>> call() async {
    return await repository.getSubscriptionVideos();
  }
}
