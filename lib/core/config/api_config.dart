/// Configuration for API services
class ApiConfig {
  /// YouTube Data API key
  /// Note: In a production app, this should be stored securely
  /// and not hardcoded in the source code
  static const String youtubeApiKey = 'AIzaSyBKKkCHt1AX9sxK7_0oAK4IcVvWpY557D8';
  
  /// YouTube Data API base URL
  static const String youtubeBaseUrl = 'https://www.googleapis.com/youtube/v3';
  
  /// Default maximum results per page
  static const int defaultMaxResults = 10;
  
  /// Default search type
  static const String defaultSearchType = 'video';
  
  /// Default video part
  static const String defaultVideoPart = 'snippet,contentDetails,statistics';
  
  /// Default search part
  static const String defaultSearchPart = 'snippet';
}
