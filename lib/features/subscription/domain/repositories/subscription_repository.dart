import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/channel.dart';
import '../entities/subscription_video.dart';
import '../entities/subscription_filter.dart';

/// Repository interface for subscription-related operations
abstract class SubscriptionRepository {
  /// Get all subscribed channels
  Future<Either<Failure, List<Channel>>> getSubscribedChannels();
  
  /// Get videos from subscribed channels
  Future<Either<Failure, List<SubscriptionVideo>>> getSubscriptionVideos();
  
  /// Get videos from subscribed channels filtered by a specific filter
  Future<Either<Failure, List<SubscriptionVideo>>> getFilteredSubscriptionVideos(String filter);
  
  /// Get available filters for subscription videos
  Future<Either<Failure, List<SubscriptionFilter>>> getSubscriptionFilters();
  
  /// Subscribe to a channel
  Future<Either<Failure, bool>> subscribeToChannel(String channelId);
  
  /// Unsubscribe from a channel
  Future<Either<Failure, bool>> unsubscribeFromChannel(String channelId);
}
