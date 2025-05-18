/// Entity representing a short video in the application
class Short {
  final String id;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final String author;
  final String authorAvatar;
  final int likes;
  final int comments;
  final int shares;
  final bool isSubscribed;
  final String music;
  final String description;

  const Short({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.author,
    required this.authorAvatar,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isSubscribed,
    required this.music,
    required this.description,
  });
}
