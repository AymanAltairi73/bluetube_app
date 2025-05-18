import '../../domain/entities/related_video.dart';

/// Data model for related videos
class RelatedVideoModel extends RelatedVideo {
  const RelatedVideoModel({
    required super.id,
    required super.title,
    required super.thumbnailUrl,
    required super.channelName,
    required super.channelAvatar,
    required super.views,
    required super.publishedAt,
    required super.duration,
    required super.isLive,
  });

  /// Create a model from JSON
  factory RelatedVideoModel.fromJson(Map<String, dynamic> json) {
    return RelatedVideoModel(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnail_url'],
      channelName: json['channel_name'],
      channelAvatar: json['channel_avatar'],
      views: json['views'] is int ? json['views'] : int.parse(json['views'].toString().replaceAll(RegExp(r'[^0-9]'), '')),
      publishedAt: DateTime.parse(json['published_at']),
      duration: json['duration'],
      isLive: json['is_live'] ?? false,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail_url': thumbnailUrl,
      'channel_name': channelName,
      'channel_avatar': channelAvatar,
      'views': views,
      'published_at': publishedAt.toIso8601String(),
      'duration': duration,
      'is_live': isLive,
    };
  }
}
