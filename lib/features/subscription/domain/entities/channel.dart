/// Entity representing a channel in the application
class Channel {
  final String id;
  final String name;
  final String image;
  final int subscribers;
  final bool hasNewContent;
  final bool isVerified;
  final String description;

  const Channel({
    required this.id,
    required this.name,
    required this.image,
    required this.subscribers,
    required this.hasNewContent,
    required this.isVerified,
    required this.description,
  });
}
