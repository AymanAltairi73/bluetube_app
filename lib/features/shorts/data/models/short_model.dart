import '../../domain/entities/short.dart';

/// Data model for shorts
class ShortModel extends Short {
  const ShortModel({
    required super.id,
    required super.title,
    required super.videoUrl,
    required super.thumbnailUrl,
    required super.author,
    required super.authorAvatar,
    required super.likes,
    required super.comments,
    required super.shares,
    required super.isSubscribed,
    required super.music,
    required super.description,
  });

  /// Create a model from JSON
  factory ShortModel.fromJson(Map<String, dynamic> json) {
    return ShortModel(
      id: json['id'],
      title: json['title'],
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      author: json['author'],
      authorAvatar: json['author_avatar'],
      likes: json['likes'],
      comments: json['comments'],
      shares: json['shares'],
      isSubscribed: json['is_subscribed'],
      music: json['music'],
      description: json['description'],
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'author': author,
      'author_avatar': authorAvatar,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'is_subscribed': isSubscribed,
      'music': music,
      'description': description,
    };
  }
}
