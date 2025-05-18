/// Entity representing an item in the user's library
class LibraryItem {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelName;
  final DateTime createdAt;
  final LibraryItemType type;

  const LibraryItem({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelName,
    required this.createdAt,
    required this.type,
  });
}

/// Types of items that can be in the library
enum LibraryItemType {
  watchLater,
  history,
  playlist,
  likedVideo,
  savedVideo,
}
