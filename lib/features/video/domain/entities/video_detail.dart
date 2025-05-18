/// Entity representing detailed information about a video
class VideoDetail {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String channelId;
  final String channelName;
  final String channelAvatar;
  final int views;
  final int likes;
  final int dislikes;
  final DateTime publishedAt;
  final bool isLiked;
  final bool isDisliked;
  final bool isSubscribed;
  final int subscriberCount;
  final List<String> tags;
  final String category;
  final bool isLive;

  const VideoDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.channelId,
    required this.channelName,
    required this.channelAvatar,
    required this.views,
    required this.likes,
    required this.dislikes,
    required this.publishedAt,
    required this.isLiked,
    required this.isDisliked,
    required this.isSubscribed,
    required this.subscriberCount,
    required this.tags,
    required this.category,
    required this.isLive,
  });
}
