import 'package:equatable/equatable.dart';
import '../../../../core/utils/duration_formatter.dart';

/// Entity class for saved videos (Watch Later)
class SavedVideo extends Equatable {
  /// Unique identifier for the video
  final String id;

  /// Title of the video
  final String title;

  /// URL for the high quality thumbnail
  final String thumbnailUrl;

  /// Title of the channel that uploaded the video
  final String channelTitle;

  /// Date and time when the video was saved
  final DateTime savedAt;

  /// Duration of the video in ISO 8601 format
  final String? duration;

  /// Constructor
  const SavedVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.savedAt,
    this.duration,
  });

  /// Get a formatted duration (convert from ISO 8601 to readable format)
  String get formattedDuration {
    return DurationFormatter.formatIsoDuration(duration);
  }

  /// Create a SavedVideo from a YouTubeVideo
  factory SavedVideo.fromYouTubeVideo({
    required String id,
    required String title,
    required String thumbnailUrl,
    required String channelTitle,
    String? duration,
  }) {
    return SavedVideo(
      id: id,
      title: title,
      thumbnailUrl: thumbnailUrl,
      channelTitle: channelTitle,
      savedAt: DateTime.now(),
      duration: duration,
    );
  }

  /// Convert to a Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'channelTitle': channelTitle,
      'savedAt': savedAt.toIso8601String(),
      'duration': duration,
    };
  }

  /// Create a SavedVideo from a Map
  factory SavedVideo.fromJson(Map<String, dynamic> json) {
    return SavedVideo(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      channelTitle: json['channelTitle'],
      savedAt: DateTime.parse(json['savedAt']),
      duration: json['duration'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        thumbnailUrl,
        channelTitle,
        savedAt,
        duration,
      ];
}
