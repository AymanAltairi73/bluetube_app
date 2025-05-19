import 'package:equatable/equatable.dart';

/// Entity class for YouTube channel
class YouTubeChannel extends Equatable {
  /// Channel ID
  final String id;
  
  /// Channel title
  final String title;
  
  /// Channel description
  final String description;
  
  /// Default thumbnail URL
  final String thumbnailUrl;
  
  /// Medium quality thumbnail URL
  final String thumbnailMediumUrl;
  
  /// High quality thumbnail URL
  final String thumbnailHighUrl;
  
  /// Subscriber count
  final int subscriberCount;
  
  /// Video count
  final int videoCount;
  
  /// View count
  final int viewCount;
  
  /// Whether the channel is verified
  final bool isVerified;
  
  /// Channel creation date
  final DateTime publishedAt;
  
  /// Channel country
  final String country;

  /// Constructor
  const YouTubeChannel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.thumbnailMediumUrl,
    required this.thumbnailHighUrl,
    required this.subscriberCount,
    required this.videoCount,
    required this.viewCount,
    required this.isVerified,
    required this.publishedAt,
    required this.country,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        thumbnailUrl,
        thumbnailMediumUrl,
        thumbnailHighUrl,
        subscriberCount,
        videoCount,
        viewCount,
        isVerified,
        publishedAt,
        country,
      ];
}
