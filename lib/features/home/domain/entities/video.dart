/// Entity representing a video in the application
class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelName;
  final String channelAvatar;
  final int views;
  final DateTime publishedAt;
  final String duration;
  final int likes;
  final int dislikes;
  final bool isLive;
  final String description;

  const Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelName,
    required this.channelAvatar,
    required this.views,
    required this.publishedAt,
    required this.duration,
    required this.likes,
    required this.dislikes,
    required this.isLive,
    required this.description,
  });
}
