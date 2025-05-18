import '../../domain/entities/video_detail.dart';

/// Data model for video details
class VideoDetailModel extends VideoDetail {
  const VideoDetailModel({
    required super.id,
    required super.title,
    required super.description,
    required super.videoUrl,
    required super.thumbnailUrl,
    required super.channelId,
    required super.channelName,
    required super.channelAvatar,
    required super.views,
    required super.likes,
    required super.dislikes,
    required super.publishedAt,
    required super.isLiked,
    required super.isDisliked,
    required super.isSubscribed,
    required super.subscriberCount,
    required super.tags,
    required super.category,
    required super.isLive,
  });

  /// Create a model from JSON
  factory VideoDetailModel.fromJson(Map<String, dynamic> json) {
    return VideoDetailModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      channelId: json['channel_id'],
      channelName: json['channel_name'],
      channelAvatar: json['channel_avatar'],
      views: json['views'] is int ? json['views'] : int.parse(json['views'].toString().replaceAll(RegExp(r'[^0-9]'), '')),
      likes: json['likes'] is int ? json['likes'] : 0,
      dislikes: json['dislikes'] is int ? json['dislikes'] : 0,
      publishedAt: DateTime.parse(json['published_at']),
      isLiked: json['is_liked'] ?? false,
      isDisliked: json['is_disliked'] ?? false,
      isSubscribed: json['is_subscribed'] ?? false,
      subscriberCount: json['subscriber_count'] is int ? json['subscriber_count'] : 0,
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] ?? 'Uncategorized',
      isLive: json['is_live'] ?? false,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'channel_id': channelId,
      'channel_name': channelName,
      'channel_avatar': channelAvatar,
      'views': views,
      'likes': likes,
      'dislikes': dislikes,
      'published_at': publishedAt.toIso8601String(),
      'is_liked': isLiked,
      'is_disliked': isDisliked,
      'is_subscribed': isSubscribed,
      'subscriber_count': subscriberCount,
      'tags': tags,
      'category': category,
      'is_live': isLive,
    };
  }
}
