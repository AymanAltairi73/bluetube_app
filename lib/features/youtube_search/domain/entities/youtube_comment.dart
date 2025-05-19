import 'package:equatable/equatable.dart';

/// Entity class for YouTube comment
class YouTubeComment extends Equatable {
  /// Comment ID
  final String id;
  
  /// Video ID
  final String videoId;
  
  /// Comment text
  final String text;
  
  /// Author display name
  final String authorDisplayName;
  
  /// Author profile image URL
  final String authorProfileImageUrl;
  
  /// Author channel ID
  final String authorChannelId;
  
  /// Like count
  final int likeCount;
  
  /// Published date
  final DateTime publishedAt;
  
  /// Updated date
  final DateTime updatedAt;
  
  /// Total reply count
  final int totalReplyCount;

  /// Constructor
  const YouTubeComment({
    required this.id,
    required this.videoId,
    required this.text,
    required this.authorDisplayName,
    required this.authorProfileImageUrl,
    required this.authorChannelId,
    required this.likeCount,
    required this.publishedAt,
    required this.updatedAt,
    required this.totalReplyCount,
  });

  @override
  List<Object?> get props => [
        id,
        videoId,
        text,
        authorDisplayName,
        authorProfileImageUrl,
        authorChannelId,
        likeCount,
        publishedAt,
        updatedAt,
        totalReplyCount,
      ];
}
