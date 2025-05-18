/// Entity representing a video in the subscription feed
class SubscriptionVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelId;
  final String channelName;
  final String channelAvatar;
  final int views;
  final DateTime publishedAt;
  final String duration;
  final bool isShort;
  final bool isLive;

  const SubscriptionVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelId,
    required this.channelName,
    required this.channelAvatar,
    required this.views,
    required this.publishedAt,
    required this.duration,
    required this.isShort,
    required this.isLive,
  });
}
