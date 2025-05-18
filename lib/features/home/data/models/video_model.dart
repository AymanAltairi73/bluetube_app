import '../../domain/entities/video.dart';

/// Data model for videos
class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.title,
    required super.thumbnailUrl,
    required super.channelName,
    required super.channelAvatar,
    required super.views,
    required super.publishedAt,
    required super.duration,
    required super.likes,
    required super.dislikes,
    required super.isLive,
    required super.description,
  });

  /// Create a model from JSON
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnail_url'],
      channelName: json['channel_name'],
      channelAvatar: json['channel_avatar'],
      views: json['views'] is int ? json['views'] : int.parse(json['views'].toString().replaceAll(RegExp(r'[^0-9]'), '')),
      publishedAt: DateTime.parse(json['published_at']),
      duration: json['duration'],
      likes: json['likes'] is int ? json['likes'] : 0,
      dislikes: json['dislikes'] is int ? json['dislikes'] : 0,
      isLive: json['is_live'] ?? false,
      description: json['description'] ?? '',
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
      'likes': likes,
      'dislikes': dislikes,
      'is_live': isLive,
      'description': description,
    };
  }
}
