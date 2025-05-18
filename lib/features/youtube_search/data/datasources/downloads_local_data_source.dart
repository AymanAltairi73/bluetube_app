import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/downloaded_video.dart';
import '../../domain/entities/youtube_video.dart';

/// Abstract class for downloads local data source
abstract class DownloadsLocalDataSource {
  /// Get all downloaded videos
  Future<List<DownloadedVideo>> getDownloadedVideos();

  /// Download a video
  Future<DownloadedVideo> downloadVideo(
    YouTubeVideo video, {
    String quality = '720p',
  });

  /// Delete a downloaded video
  Future<bool> deleteDownloadedVideo(String videoId);

  /// Check if a video is downloaded
  Future<bool> isVideoDownloaded(String videoId);

  /// Get a downloaded video by ID
  Future<DownloadedVideo?> getDownloadedVideo(String videoId);

  /// Get the total size of all downloaded videos
  Future<int> getTotalDownloadSize();
}

/// Implementation of [DownloadsLocalDataSource] using GetStorage and local file system
class DownloadsLocalDataSourceImpl implements DownloadsLocalDataSource {
  final GetStorage storage;
  final DefaultCacheManager cacheManager;
  static const String downloadsKey = 'downloaded_videos';
  static const String downloadsDir = 'downloads';

  /// Constructor
  DownloadsLocalDataSourceImpl({
    required this.storage,
    required this.cacheManager,
  });

  @override
  Future<List<DownloadedVideo>> getDownloadedVideos() async {
    try {
      final jsonString = storage.read<String>(downloadsKey);

      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => DownloadedVideo.fromJson(json))
          .toList()
          .reversed // Show newest first
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get downloaded videos: ${e.toString()}');
    }
  }

  @override
  Future<DownloadedVideo> downloadVideo(
    YouTubeVideo video, {
    String quality = '720p',
  }) async {
    // Track created files for cleanup in case of failure
    final List<String> createdFiles = [];
    DownloadedVideo? downloadedVideo;

    try {
      // Check if video is already downloaded
      final existingVideo = await getDownloadedVideo(video.id);
      if (existingVideo != null) {
        return existingVideo;
      }

      // Create downloads directory if it doesn't exist
      final appDir = await getApplicationDocumentsDirectory();
      final downloadsPath = '${appDir.path}/$downloadsDir';
      final dir = Directory(downloadsPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Define file paths
      final thumbnailPath = '$downloadsPath/${video.id}_thumbnail.jpg';
      final videoPath = '$downloadsPath/${video.id}_video.mp4';

      // Download thumbnail with error handling
      FileInfo? fileInfo;
      try {
        fileInfo = await cacheManager.downloadFile(
          video.thumbnailHighUrl,
          key: 'thumbnail_${video.id}',
        );

        // Save thumbnail to downloads directory
        await fileInfo.file.copy(thumbnailPath);
        createdFiles.add(thumbnailPath);
        debugPrint('Thumbnail saved to: $thumbnailPath');
      } catch (e) {
        debugPrint('Error downloading thumbnail: $e');
        // Continue with video download even if thumbnail fails
      }

      // Create a mock video file (in a real app, this would be the actual video)
      try {
        final videoFile = File(videoPath);
        await videoFile.writeAsString('Mock video content for ${video.title}');
        createdFiles.add(videoPath);
        debugPrint('Video saved to: $videoPath');
      } catch (e) {
        // If video file creation fails, clean up and throw
        await _cleanupCreatedFiles(createdFiles);
        throw CacheException(message: 'Failed to create video file: ${e.toString()}');
      }

      // Get file size
      int fileSize = 0;
      try {
        final videoFile = File(videoPath);
        fileSize = await videoFile.length();
      } catch (e) {
        debugPrint('Error getting file size: $e');
        // Use a default size if we can't get the actual size
        fileSize = 1024 * 1024; // 1MB default
      }

      // Create downloaded video entity
      downloadedVideo = DownloadedVideo(
        id: video.id,
        title: video.title,
        thumbnailUrl: thumbnailPath, // Use local path
        channelTitle: video.channelTitle,
        downloadedAt: DateTime.now(),
        duration: video.duration,
        filePath: videoPath,
        fileSize: fileSize,
        quality: quality,
      );

      // Save to storage with transaction-like behavior
      try {
        final currentVideos = await getDownloadedVideos();

        // Check again if video was added while we were downloading
        if (currentVideos.any((v) => v.id == video.id)) {
          // Video was added by another process, clean up our files
          await _cleanupCreatedFiles(createdFiles);
          // Return the existing video
          return currentVideos.firstWhere((v) => v.id == video.id);
        }

        final updatedVideos = [...currentVideos, downloadedVideo];
        final jsonList = updatedVideos.map((v) => v.toJson()).toList();
        await storage.write(downloadsKey, json.encode(jsonList));

        return downloadedVideo;
      } catch (e) {
        // If storage update fails, clean up created files
        await _cleanupCreatedFiles(createdFiles);
        throw CacheException(message: 'Failed to update storage: ${e.toString()}');
      }
    } catch (e) {
      // Clean up any created files on failure
      await _cleanupCreatedFiles(createdFiles);
      throw CacheException(message: 'Failed to download video: ${e.toString()}');
    }
  }

  /// Helper method to clean up created files on failure
  Future<void> _cleanupCreatedFiles(List<String> filePaths) async {
    for (final path in filePaths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
          debugPrint('Cleaned up file: $path');
        }
      } catch (e) {
        debugPrint('Error cleaning up file $path: $e');
      }
    }
  }

  @override
  Future<bool> deleteDownloadedVideo(String videoId) async {
    // Track what files were successfully deleted for rollback if needed
    final List<String> deletedFiles = [];
    bool metadataRemoved = false;

    try {
      // Get the downloaded video
      final downloadedVideo = await getDownloadedVideo(videoId);
      if (downloadedVideo == null) {
        return false;
      }

      // Get the current videos list
      final currentVideos = await getDownloadedVideos();

      // Delete the video file with proper error handling
      final videoFile = File(downloadedVideo.filePath);
      if (await videoFile.exists()) {
        try {
          await videoFile.delete();
          deletedFiles.add(downloadedVideo.filePath);
        } catch (e) {
          debugPrint('Error deleting video file: $e');
          // Continue with other deletions even if this fails
        }
      }

      // Delete the thumbnail file with proper error handling
      final thumbnailFile = File(downloadedVideo.thumbnailUrl);
      if (await thumbnailFile.exists()) {
        try {
          await thumbnailFile.delete();
          deletedFiles.add(downloadedVideo.thumbnailUrl);
        } catch (e) {
          debugPrint('Error deleting thumbnail file: $e');
          // Continue with metadata removal even if this fails
        }
      }

      // Remove from storage in a transaction-like manner
      try {
        final updatedVideos = currentVideos.where((v) => v.id != videoId).toList();
        final jsonList = updatedVideos.map((v) => v.toJson()).toList();
        await storage.write(downloadsKey, json.encode(jsonList));
        metadataRemoved = true;
      } catch (e) {
        // If metadata removal fails, try to restore deleted files
        await _rollbackFileDeletions(deletedFiles);
        throw CacheException(message: 'Failed to update storage: ${e.toString()}');
      }

      return true;
    } catch (e) {
      // If any step fails, try to restore consistency
      if (metadataRemoved && deletedFiles.isNotEmpty) {
        // Files were deleted but metadata was updated - inconsistent state
        // This is harder to recover from, but we'll log it
        debugPrint('Warning: Inconsistent state after deletion failure. Some files may be orphaned.');
      } else if (!metadataRemoved) {
        // Try to restore any deleted files since metadata wasn't updated
        await _rollbackFileDeletions(deletedFiles);
      }

      throw CacheException(message: 'Failed to delete downloaded video: ${e.toString()}');
    }
  }

  /// Helper method to attempt restoration of deleted files
  Future<void> _rollbackFileDeletions(List<String> deletedFilePaths) async {
    for (final path in deletedFilePaths) {
      try {
        // We can't actually restore the files, but we can log the failure
        debugPrint('Cannot restore deleted file: $path');
      } catch (e) {
        debugPrint('Error during rollback: $e');
      }
    }
  }

  @override
  Future<bool> isVideoDownloaded(String videoId) async {
    try {
      final downloadedVideo = await getDownloadedVideo(videoId);
      return downloadedVideo != null;
    } catch (e) {
      throw CacheException(message: 'Failed to check if video is downloaded: ${e.toString()}');
    }
  }

  @override
  Future<DownloadedVideo?> getDownloadedVideo(String videoId) async {
    try {
      final videos = await getDownloadedVideos();
      return videos.firstWhere(
        (v) => v.id == videoId,
        orElse: () => throw StateError('Video not found'),
      );
    } catch (e) {
      if (e is StateError) {
        return null;
      }
      throw CacheException(message: 'Failed to get downloaded video: ${e.toString()}');
    }
  }

  @override
  Future<int> getTotalDownloadSize() async {
    try {
      final videos = await getDownloadedVideos();
      int totalSize = 0;
      for (final video in videos) {
        totalSize += video.fileSize;
      }
      return totalSize;
    } catch (e) {
      throw CacheException(message: 'Failed to get total download size: ${e.toString()}');
    }
  }
}
