/// Entity representing a video in the explore screen
class ExploreVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelName;
  final String channelLogo;
  final String views;
  final String timeAgo;
  final String duration;
  final bool isLive;

  const ExploreVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelName,
    required this.channelLogo,
    required this.views,
    required this.timeAgo,
    required this.duration,
    required this.isLive,
  });
}
