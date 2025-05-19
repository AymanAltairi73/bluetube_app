import 'youtube_comment_model.dart';

/// Model class for YouTube comments response
class YouTubeCommentsResponseModel {
  /// List of comment results
  final List<YouTubeCommentModel> comments;
  
  /// Token for the next page of results
  final String? nextPageToken;
  
  /// Token for the previous page of results
  final String? prevPageToken;
  
  /// Total results count
  final int totalResults;
  
  /// Results per page
  final int resultsPerPage;

  /// Constructor
  YouTubeCommentsResponseModel({
    required this.comments,
    this.nextPageToken,
    this.prevPageToken,
    required this.totalResults,
    required this.resultsPerPage,
  });

  /// Create a YouTubeCommentsResponseModel from JSON
  factory YouTubeCommentsResponseModel.fromJson(Map<String, dynamic> json) {
    final items = json['items'] as List? ?? [];
    
    return YouTubeCommentsResponseModel(
      comments: items
          .map((item) => YouTubeCommentModel.fromJson(item))
          .toList(),
      nextPageToken: json['nextPageToken'],
      prevPageToken: json['prevPageToken'],
      totalResults: json['pageInfo']?['totalResults'] ?? 0,
      resultsPerPage: json['pageInfo']?['resultsPerPage'] ?? 0,
    );
  }
}
