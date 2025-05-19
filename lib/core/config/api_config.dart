/// Configuration for mock data services and API parameters
class ApiConfig {
  /// Default maximum results per page
  static const int defaultMaxResults = 10;

  /// Default search type
  static const String defaultSearchType = 'video';

  /// Default video part
  static const String defaultVideoPart = 'snippet,contentDetails,statistics';

  /// Default search part
  static const String defaultSearchPart = 'snippet';

  /// Default region code
  static const String defaultRegionCode = 'US';

  /// Simulated network delay range in milliseconds (min)
  static const int minNetworkDelay = 200;

  /// Simulated network delay range in milliseconds (max)
  static const int maxNetworkDelay = 800;

  /// Probability of simulated network error (0.0 to 1.0)
  static const double errorProbability = 0.1;
}
