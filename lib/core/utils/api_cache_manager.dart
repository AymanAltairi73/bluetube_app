import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Cache manager for API responses
class ApiCacheManager {
  final DefaultCacheManager _cacheManager;

  /// Default TTL for cached responses (5 minutes)
  static const Duration defaultTtl = Duration(minutes: 5);

  /// TTL for trending videos (15 minutes)
  static const Duration trendingTtl = Duration(minutes: 15);

  /// TTL for video details (1 hour)
  static const Duration videoDetailsTtl = Duration(hours: 1);

  /// TTL for channel details (2 hours)
  static const Duration channelDetailsTtl = Duration(hours: 2);

  /// Constructor
  ApiCacheManager(this._cacheManager);

  /// Cache an API response
  Future<void> cacheApiResponse(
    String key,
    Map<String, dynamic> response, {
    Duration ttl = defaultTtl,
  }) async {
    final jsonString = json.encode(response);
    await _cacheManager.putFile(
      key,
      Uint8List.fromList(utf8.encode(jsonString)),
      maxAge: ttl,
      fileExtension: 'json',
    );
  }

  /// Get a cached API response
  Future<Map<String, dynamic>?> getCachedApiResponse(String key) async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache(key);
      if (fileInfo == null) {
        return null;
      }

      final jsonString = await fileInfo.file.readAsString();
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Clear all cached responses
  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }

  /// Clear a specific cached response
  Future<void> clearCachedResponse(String key) async {
    await _cacheManager.removeFile(key);
  }

  /// Generate a cache key for a search query
  static String generateSearchKey(String query, {String? pageToken}) {
    return 'search_${query}_${pageToken ?? "first"}';
  }

  /// Generate a cache key for trending videos
  static String generateTrendingKey(String regionCode, String? categoryId, {String? pageToken}) {
    return 'trending_${regionCode}_${categoryId ?? "all"}_${pageToken ?? "first"}';
  }

  /// Generate a cache key for videos by category
  static String generateCategoryKey(String categoryId, {String? pageToken}) {
    return 'category_${categoryId}_${pageToken ?? "first"}';
  }

  /// Generate a cache key for video details
  static String generateVideoDetailsKey(String videoId) {
    return 'video_$videoId';
  }

  /// Generate a cache key for channel details
  static String generateChannelKey(String channelId) {
    return 'channel_$channelId';
  }

  /// Generate a cache key for video comments
  static String generateCommentsKey(String videoId, {String? pageToken}) {
    return 'comments_${videoId}_${pageToken ?? "first"}';
  }

  /// Generate a cache key for related videos
  static String generateRelatedKey(String videoId, {String? pageToken}) {
    return 'related_${videoId}_${pageToken ?? "first"}';
  }
}
