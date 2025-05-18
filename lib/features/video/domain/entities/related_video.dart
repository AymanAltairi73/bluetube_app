/// Entity representing a related video recommendation
class RelatedVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelName;
  final String channelAvatar;
  final int views;
  final DateTime publishedAt;
  final String duration;
  final bool isLive;

  const RelatedVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelName,
    required this.channelAvatar,
    required this.views,
    required this.publishedAt,
    required this.duration,
    required this.isLive,
  });
}
