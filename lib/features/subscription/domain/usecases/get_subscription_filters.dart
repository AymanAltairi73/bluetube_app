import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/subscription_filter.dart';
import '../repositories/subscription_repository.dart';

/// Use case for getting available filters for subscription videos
class GetSubscriptionFilters {
  final SubscriptionRepository repository;

  GetSubscriptionFilters(this.repository);

  Future<Either<Failure, List<SubscriptionFilter>>> call() async {
    return await repository.getSubscriptionFilters();
  }
}
