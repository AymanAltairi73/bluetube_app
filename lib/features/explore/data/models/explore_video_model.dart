import '../../domain/entities/explore_video.dart';

/// Data model for explore videos
class ExploreVideoModel extends ExploreVideo {
  const ExploreVideoModel({
    required super.id,
    required super.title,
    required super.thumbnailUrl,
    required super.channelName,
    required super.channelLogo,
    required super.views,
    required super.timeAgo,
    required super.duration,
    required super.isLive,
  });

  /// Create a model from JSON
  factory ExploreVideoModel.fromJson(Map<String, dynamic> json) {
    return ExploreVideoModel(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnail_url'],
      channelName: json['channel_name'],
      channelLogo: json['channel_logo'],
      views: json['views'],
      timeAgo: json['time_ago'],
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
      'channel_logo': channelLogo,
      'views': views,
      'time_ago': timeAgo,
      'duration': duration,
      'is_live': isLive,
    };
  }
}
