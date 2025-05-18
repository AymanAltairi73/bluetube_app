import 'package:equatable/equatable.dart';
import '../../../../core/utils/duration_formatter.dart';

/// Entity class for downloaded videos
class DownloadedVideo extends Equatable {
  /// Unique identifier for the video
  final String id;

  /// Title of the video
  final String title;

  /// URL for the high quality thumbnail
  final String thumbnailUrl;

  /// Title of the channel that uploaded the video
  final String channelTitle;

  /// Date and time when the video was downloaded
  final DateTime downloadedAt;

  /// Duration of the video in ISO 8601 format
  final String? duration;

  /// Local file path where the video is stored
  final String filePath;

  /// Size of the downloaded file in bytes
  final int fileSize;

  /// Quality of the downloaded video (e.g., '720p')
  final String quality;

  /// Constructor
  const DownloadedVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.downloadedAt,
    required this.filePath,
    required this.fileSize,
    required this.quality,
    this.duration,
  });

  /// Get a formatted duration (convert from ISO 8601 to readable format)
  String get formattedDuration {
    return DurationFormatter.formatIsoDuration(duration);
  }

  /// Get a formatted file size (e.g., '10.5 MB')
  String get formattedFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      final kb = fileSize / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    } else if (fileSize < 1024 * 1024 * 1024) {
      final mb = fileSize / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} MB';
    } else {
      final gb = fileSize / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(1)} GB';
    }
  }

  /// Convert to a Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'channelTitle': channelTitle,
      'downloadedAt': downloadedAt.toIso8601String(),
      'duration': duration,
      'filePath': filePath,
      'fileSize': fileSize,
      'quality': quality,
    };
  }

  /// Create a DownloadedVideo from a Map
  factory DownloadedVideo.fromJson(Map<String, dynamic> json) {
    return DownloadedVideo(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      channelTitle: json['channelTitle'],
      downloadedAt: DateTime.parse(json['downloadedAt']),
      duration: json['duration'],
      filePath: json['filePath'],
      fileSize: json['fileSize'],
      quality: json['quality'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        thumbnailUrl,
        channelTitle,
        downloadedAt,
        duration,
        filePath,
        fileSize,
        quality,
      ];
}
