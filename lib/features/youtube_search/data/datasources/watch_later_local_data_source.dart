import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/saved_video.dart';

/// Abstract class for Watch Later local data source
abstract class WatchLaterLocalDataSource {
  /// Get all saved videos
  Future<List<SavedVideo>> getSavedVideos();

  /// Save a video to Watch Later
  Future<bool> saveVideo(SavedVideo video);

  /// Remove a video from Watch Later
  Future<bool> removeVideo(String videoId);

  /// Check if a video is saved
  Future<bool> isVideoSaved(String videoId);
}

/// Implementation of [WatchLaterLocalDataSource] using GetStorage
class WatchLaterLocalDataSourceImpl implements WatchLaterLocalDataSource {
  final GetStorage storage;
  static const String watchLaterKey = 'watch_later_videos';

  /// Constructor
  WatchLaterLocalDataSourceImpl({required this.storage});

  @override
  Future<List<SavedVideo>> getSavedVideos() async {
    try {
      final jsonString = storage.read<String>(watchLaterKey);

      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => SavedVideo.fromJson(json))
          .toList()
          .reversed // Show newest first
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get saved videos: ${e.toString()}');
    }
  }

  @override
  Future<bool> saveVideo(SavedVideo video, {int maxRetries = 3}) async {
    int attempts = 0;
    int backoffMs = 300; // Start with 300ms backoff

    while (attempts < maxRetries) {
      try {
        // Increment attempt counter
        attempts++;

        // Get current videos list
        final currentVideos = await getSavedVideos();

        // Check if video is already saved
        if (currentVideos.any((v) => v.id == video.id)) {
          return true; // Already saved
        }

        // Prepare updated list
        final updatedVideos = [...currentVideos, video];
        final jsonList = updatedVideos.map((v) => v.toJson()).toList();

        // Write to storage
        await storage.write(watchLaterKey, json.encode(jsonList));

        // If we get here, the save was successful
        debugPrint('Video saved successfully on attempt $attempts');
        return true;
      } catch (e) {
        // If this was our last attempt, throw the exception
        if (attempts >= maxRetries) {
          throw CacheException(message: 'Failed to save video after $maxRetries attempts: ${e.toString()}');
        }

        // Log the failure
        debugPrint('Save attempt $attempts failed: $e. Retrying in ${backoffMs}ms...');

        // Wait with exponential backoff before retrying
        await Future.delayed(Duration(milliseconds: backoffMs));

        // Increase backoff for next attempt (exponential backoff with jitter)
        backoffMs = (backoffMs * 1.5 + Random().nextInt(100)).toInt();
      }
    }

    // This should never be reached due to the throw in the catch block
    throw CacheException(message: 'Failed to save video: Unexpected error');
  }

  @override
  Future<bool> removeVideo(String videoId) async {
    try {
      final currentVideos = await getSavedVideos();
      final updatedVideos = currentVideos.where((v) => v.id != videoId).toList();

      final jsonList = updatedVideos.map((v) => v.toJson()).toList();
      await storage.write(watchLaterKey, json.encode(jsonList));

      return true;
    } catch (e) {
      throw CacheException(message: 'Failed to remove video: ${e.toString()}');
    }
  }

  @override
  Future<bool> isVideoSaved(String videoId) async {
    try {
      final currentVideos = await getSavedVideos();
      return currentVideos.any((v) => v.id == videoId);
    } catch (e) {
      throw CacheException(message: 'Failed to check if video is saved: ${e.toString()}');
    }
  }
}
