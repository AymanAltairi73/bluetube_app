import '../../domain/entities/youtube_channel.dart';

/// Model class for YouTube channel data from the API
class YouTubeChannelModel extends YouTubeChannel {
  const YouTubeChannelModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnailUrl,
    required super.thumbnailMediumUrl,
    required super.thumbnailHighUrl,
    required super.subscriberCount,
    required super.videoCount,
    required super.viewCount,
    required super.isVerified,
    required super.publishedAt,
    required super.country,
  });

  /// Create a YouTubeChannelModel from a channel details JSON
  factory YouTubeChannelModel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final statistics = json['statistics'];
    final thumbnails = snippet['thumbnails'];
    
    return YouTubeChannelModel(
      id: json['id'],
      title: snippet['title'],
      description: snippet['description'],
      thumbnailUrl: thumbnails['default']?['url'] ?? '',
      thumbnailMediumUrl: thumbnails['medium']?['url'] ?? '',
      thumbnailHighUrl: thumbnails['high']?['url'] ?? '',
      subscriberCount: int.tryParse(statistics['subscriberCount'] ?? '0') ?? 0,
      videoCount: int.tryParse(statistics['videoCount'] ?? '0') ?? 0,
      viewCount: int.tryParse(statistics['viewCount'] ?? '0') ?? 0,
      isVerified: false, // YouTube API doesn't provide verification status
      publishedAt: DateTime.parse(snippet['publishedAt']),
      country: snippet['country'] ?? '',
    );
  }

  /// Convert model to entity
  YouTubeChannel toEntity() {
    return YouTubeChannel(
      id: id,
      title: title,
      description: description,
      thumbnailUrl: thumbnailUrl,
      thumbnailMediumUrl: thumbnailMediumUrl,
      thumbnailHighUrl: thumbnailHighUrl,
      subscriberCount: subscriberCount,
      videoCount: videoCount,
      viewCount: viewCount,
      isVerified: isVerified,
      publishedAt: publishedAt,
      country: country,
    );
  }
}
