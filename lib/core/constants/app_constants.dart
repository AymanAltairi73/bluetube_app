/// Application-wide constants
class AppConstants {
  // API related constants
  static const String baseUrl = 'https://api.example.com';
  static const int apiTimeoutSeconds = 30;
  
  // Cache related constants
  static const String cacheBoxName = 'bluetube_cache';
  static const int cacheDurationHours = 24;
  
  // Pagination constants
  static const int defaultPageSize = 10;
  
  // Asset paths
  static const String logoPath = 'assets/images/blueTube_logo.png';
  static const String shortsIconPath = 'assets/images/shorts_icon.png';
  
  // Feature flags
  static const bool enableShorts = true;
  static const bool enableLiveStreaming = true;
  
  // App settings
  static const String appName = 'BlueTube';
  static const String appVersion = '1.0.0';
}
