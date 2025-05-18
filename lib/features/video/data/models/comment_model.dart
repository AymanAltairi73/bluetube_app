import '../../domain/entities/comment.dart';

/// Data model for comments
class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.videoId,
    required super.userId,
    required super.userName,
    required super.userAvatar,
    required super.text,
    required super.createdAt,
    required super.likes,
    required super.replies,
    required super.isLiked,
    required super.isPinned,
    required super.isOwner,
  });

  /// Create a model from JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      videoId: json['video_id'],
      userId: json['user_id'],
      userName: json['user_name'],
      userAvatar: json['user_avatar'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      likes: json['likes'] is int ? json['likes'] : 0,
      replies: json['replies'] is int ? json['replies'] : 0,
      isLiked: json['is_liked'] ?? false,
      isPinned: json['is_pinned'] ?? false,
      isOwner: json['is_owner'] ?? false,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'video_id': videoId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'text': text,
      'created_at': createdAt.toIso8601String(),
      'likes': likes,
      'replies': replies,
      'is_liked': isLiked,
      'is_pinned': isPinned,
      'is_owner': isOwner,
    };
  }
}
