import '../../domain/entities/youtube_video.dart';

/// Model class for YouTube video data from the API
class YouTubeVideoModel extends YouTubeVideo {
  const YouTubeVideoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnailUrl,
    required super.thumbnailMediumUrl,
    required super.thumbnailHighUrl,
    required super.channelTitle,
    required super.publishedAt,
    required super.viewCount,
    required super.duration,
  });

  /// Create a YouTubeVideoModel from a search result JSON
  factory YouTubeVideoModel.fromSearchJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final thumbnails = snippet['thumbnails'];
    
    return YouTubeVideoModel(
      id: json['id']['videoId'],
      title: snippet['title'],
      description: snippet['description'],
      thumbnailUrl: thumbnails['default']['url'],
      thumbnailMediumUrl: thumbnails['medium']['url'],
      thumbnailHighUrl: thumbnails['high']['url'],
      channelTitle: snippet['channelTitle'],
      publishedAt: DateTime.parse(snippet['publishedAt']),
      viewCount: null, // Not available in search results
      duration: null, // Not available in search results
    );
  }

  /// Create a YouTubeVideoModel from a video details JSON
  factory YouTubeVideoModel.fromVideoJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final thumbnails = snippet['thumbnails'];
    final statistics = json['statistics'];
    final contentDetails = json['contentDetails'];
    
    return YouTubeVideoModel(
      id: json['id'],
      title: snippet['title'],
      description: snippet['description'],
      thumbnailUrl: thumbnails['default']['url'],
      thumbnailMediumUrl: thumbnails['medium']['url'],
      thumbnailHighUrl: thumbnails['high']['url'],
      channelTitle: snippet['channelTitle'],
      publishedAt: DateTime.parse(snippet['publishedAt']),
      viewCount: int.tryParse(statistics['viewCount'] ?? '0'),
      duration: contentDetails['duration'], // ISO 8601 duration format
    );
  }

  /// Convert model to entity
  YouTubeVideo toEntity() {
    return YouTubeVideo(
      id: id,
      title: title,
      description: description,
      thumbnailUrl: thumbnailUrl,
      thumbnailMediumUrl: thumbnailMediumUrl,
      thumbnailHighUrl: thumbnailHighUrl,
      channelTitle: channelTitle,
      publishedAt: publishedAt,
      viewCount: viewCount,
      duration: duration,
    );
  }
}
