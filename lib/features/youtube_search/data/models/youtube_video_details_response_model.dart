import 'youtube_video_model.dart';

/// Model class for YouTube video details response
class YouTubeVideoDetailsResponseModel {
  /// Video details
  final YouTubeVideoModel video;

  /// Constructor
  YouTubeVideoDetailsResponseModel({
    required this.video,
  });

  /// Create a YouTubeVideoDetailsResponseModel from JSON
  factory YouTubeVideoDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final items = json['items'] as List;
    
    if (items.isEmpty) {
      throw Exception('No video details found');
    }
    
    return YouTubeVideoDetailsResponseModel(
      video: YouTubeVideoModel.fromVideoJson(items[0]),
    );
  }
}
