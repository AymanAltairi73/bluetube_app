import '../../domain/entities/youtube_comment.dart';

/// Model class for YouTube comment data from the API
class YouTubeCommentModel extends YouTubeComment {
  const YouTubeCommentModel({
    required super.id,
    required super.videoId,
    required super.text,
    required super.authorDisplayName,
    required super.authorProfileImageUrl,
    required super.authorChannelId,
    required super.likeCount,
    required super.publishedAt,
    required super.updatedAt,
    required super.totalReplyCount,
  });

  /// Create a YouTubeCommentModel from a comment JSON
  factory YouTubeCommentModel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final topLevelComment = snippet['topLevelComment']['snippet'];
    
    return YouTubeCommentModel(
      id: json['id'],
      videoId: snippet['videoId'],
      text: topLevelComment['textDisplay'],
      authorDisplayName: topLevelComment['authorDisplayName'],
      authorProfileImageUrl: topLevelComment['authorProfileImageUrl'],
      authorChannelId: topLevelComment['authorChannelId']?['value'] ?? '',
      likeCount: topLevelComment['likeCount'],
      publishedAt: DateTime.parse(topLevelComment['publishedAt']),
      updatedAt: DateTime.parse(topLevelComment['updatedAt']),
      totalReplyCount: snippet['totalReplyCount'],
    );
  }

  /// Convert model to entity
  YouTubeComment toEntity() {
    return YouTubeComment(
      id: id,
      videoId: videoId,
      text: text,
      authorDisplayName: authorDisplayName,
      authorProfileImageUrl: authorProfileImageUrl,
      authorChannelId: authorChannelId,
      likeCount: likeCount,
      publishedAt: publishedAt,
      updatedAt: updatedAt,
      totalReplyCount: totalReplyCount,
    );
  }
}
