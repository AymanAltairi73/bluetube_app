import '../../domain/entities/subscription_video.dart';

/// Data model for subscription videos
class SubscriptionVideoModel extends SubscriptionVideo {
  const SubscriptionVideoModel({
    required super.id,
    required super.title,
    required super.thumbnailUrl,
    required super.channelId,
    required super.channelName,
    required super.channelAvatar,
    required super.views,
    required super.publishedAt,
    required super.duration,
    required super.isShort,
    required super.isLive,
  });

  /// Create a model from JSON
  factory SubscriptionVideoModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionVideoModel(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnail_url'],
      channelId: json['channel_id'],
      channelName: json['channel_name'],
      channelAvatar: json['channel_avatar'],
      views: json['views'] is int ? json['views'] : int.parse(json['views'].toString().replaceAll(RegExp(r'[^0-9]'), '')),
      publishedAt: DateTime.parse(json['published_at']),
      duration: json['duration'],
      isShort: json['is_short'] ?? false,
      isLive: json['is_live'] ?? false,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail_url': thumbnailUrl,
      'channel_id': channelId,
      'channel_name': channelName,
      'channel_avatar': channelAvatar,
      'views': views,
      'published_at': publishedAt.toIso8601String(),
      'duration': duration,
      'is_short': isShort,
      'is_live': isLive,
    };
  }
}
