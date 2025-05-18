import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/subscription_video.dart';
import '../repositories/subscription_repository.dart';

/// Use case for getting filtered videos from subscribed channels
class GetFilteredSubscriptionVideos {
  final SubscriptionRepository repository;

  GetFilteredSubscriptionVideos(this.repository);

  Future<Either<Failure, List<SubscriptionVideo>>> call(String filter) async {
    return await repository.getFilteredSubscriptionVideos(filter);
  }
}
