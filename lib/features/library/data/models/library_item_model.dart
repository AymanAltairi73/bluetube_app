import '../../domain/entities/library_item.dart';

/// Data model for library items
class LibraryItemModel extends LibraryItem {
  const LibraryItemModel({
    required super.id,
    required super.title,
    required super.thumbnailUrl,
    required super.channelName,
    required super.createdAt,
    required super.type,
  });

  /// Create a model from JSON
  factory LibraryItemModel.fromJson(Map<String, dynamic> json) {
    return LibraryItemModel(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnail_url'],
      channelName: json['channel_name'],
      createdAt: DateTime.parse(json['created_at']),
      type: _mapTypeFromString(json['type']),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail_url': thumbnailUrl,
      'channel_name': channelName,
      'created_at': createdAt.toIso8601String(),
      'type': _mapTypeToString(type),
    };
  }

  /// Map string to LibraryItemType enum
  static LibraryItemType _mapTypeFromString(String type) {
    switch (type) {
      case 'watch_later':
        return LibraryItemType.watchLater;
      case 'history':
        return LibraryItemType.history;
      case 'playlist':
        return LibraryItemType.playlist;
      case 'liked_video':
        return LibraryItemType.likedVideo;
      case 'saved_video':
        return LibraryItemType.savedVideo;
      default:
        return LibraryItemType.history;
    }
  }

  /// Map LibraryItemType enum to string
  static String _mapTypeToString(LibraryItemType type) {
    switch (type) {
      case LibraryItemType.watchLater:
        return 'watch_later';
      case LibraryItemType.history:
        return 'history';
      case LibraryItemType.playlist:
        return 'playlist';
      case LibraryItemType.likedVideo:
        return 'liked_video';
      case LibraryItemType.savedVideo:
        return 'saved_video';
    }
  }
}
