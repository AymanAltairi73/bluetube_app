import 'package:equatable/equatable.dart';
import '../../../../core/utils/duration_formatter.dart';

/// Entity class for YouTube video data
class YouTubeVideo extends Equatable {
  /// Unique identifier for the video
  final String id;

  /// Title of the video
  final String title;

  /// Description of the video
  final String description;

  /// URL for the default quality thumbnail
  final String thumbnailUrl;

  /// URL for the medium quality thumbnail
  final String thumbnailMediumUrl;

  /// URL for the high quality thumbnail
  final String thumbnailHighUrl;

  /// Title of the channel that uploaded the video
  final String channelTitle;

  /// Date and time when the video was published
  final DateTime publishedAt;

  /// Number of views (may be null if not available)
  final int? viewCount;

  /// Duration of the video in ISO 8601 format (may be null if not available)
  final String? duration;

  /// Constructor
  const YouTubeVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.thumbnailMediumUrl,
    required this.thumbnailHighUrl,
    required this.channelTitle,
    required this.publishedAt,
    required this.viewCount,
    required this.duration,
  });

  /// Get a truncated description (first 100 characters)
  String get truncatedDescription {
    if (description.length <= 100) {
      return description;
    }
    return '${description.substring(0, 97)}...';
  }

  /// Get a formatted view count (e.g., "1.2M views")
  String get formattedViewCount {
    if (viewCount == null) {
      return 'No views';
    }

    if (viewCount! < 1000) {
      return '$viewCount views';
    } else if (viewCount! < 1000000) {
      final count = (viewCount! / 1000).toStringAsFixed(1);
      return '${count}K views';
    } else {
      final count = (viewCount! / 1000000).toStringAsFixed(1);
      return '${count}M views';
    }
  }

  /// Get a formatted duration (convert from ISO 8601 to readable format)
  String get formattedDuration {
    return DurationFormatter.formatIsoDuration(duration);
  }

  /// Get a formatted published date (e.g., "2 days ago")
  String get formattedPublishedDate {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        thumbnailUrl,
        thumbnailMediumUrl,
        thumbnailHighUrl,
        channelTitle,
        publishedAt,
        viewCount,
        duration,
      ];
}
