/// Entity representing a comment on a video
class Comment {
  final String id;
  final String videoId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String text;
  final DateTime createdAt;
  final int likes;
  final int replies;
  final bool isLiked;
  final bool isPinned;
  final bool isOwner;

  const Comment({
    required this.id,
    required this.videoId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.text,
    required this.createdAt,
    required this.likes,
    required this.replies,
    required this.isLiked,
    required this.isPinned,
    required this.isOwner,
  });
}
