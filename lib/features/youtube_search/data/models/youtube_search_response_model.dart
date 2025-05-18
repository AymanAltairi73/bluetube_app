import 'youtube_video_model.dart';

/// Model class for YouTube search response
class YouTubeSearchResponseModel {
  /// List of video results
  final List<YouTubeVideoModel> videos;
  
  /// Token for the next page of results
  final String? nextPageToken;
  
  /// Token for the previous page of results
  final String? prevPageToken;
  
  /// Total results count
  final int totalResults;
  
  /// Results per page
  final int resultsPerPage;

  /// Constructor
  YouTubeSearchResponseModel({
    required this.videos,
    this.nextPageToken,
    this.prevPageToken,
    required this.totalResults,
    required this.resultsPerPage,
  });

  /// Create a YouTubeSearchResponseModel from JSON
  factory YouTubeSearchResponseModel.fromJson(Map<String, dynamic> json) {
    final items = json['items'] as List;
    
    return YouTubeSearchResponseModel(
      videos: items
          .map((item) => YouTubeVideoModel.fromSearchJson(item))
          .toList(),
      nextPageToken: json['nextPageToken'],
      prevPageToken: json['prevPageToken'],
      totalResults: json['pageInfo']['totalResults'],
      resultsPerPage: json['pageInfo']['resultsPerPage'],
    );
  }
}
