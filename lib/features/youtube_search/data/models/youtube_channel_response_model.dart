import 'youtube_channel_model.dart';

/// Model class for YouTube channel response
class YouTubeChannelResponseModel {
  /// Channel details
  final YouTubeChannelModel channel;

  /// Constructor
  YouTubeChannelResponseModel({
    required this.channel,
  });

  /// Create a YouTubeChannelResponseModel from JSON
  factory YouTubeChannelResponseModel.fromJson(Map<String, dynamic> json) {
    final items = json['items'] as List;
    
    if (items.isEmpty) {
      throw Exception('No channel details found');
    }
    
    return YouTubeChannelResponseModel(
      channel: YouTubeChannelModel.fromJson(items[0]),
    );
  }
}
