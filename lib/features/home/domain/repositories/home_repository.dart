import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/video.dart';
import '../entities/category.dart';

/// Repository interface for home-related operations
abstract class HomeRepository {
  /// Get all videos for the home feed
  Future<Either<Failure, List<Video>>> getVideos();
  
  /// Get videos by category
  Future<Either<Failure, List<Video>>> getVideosByCategory(String category);
  
  /// Get all available categories
  Future<Either<Failure, List<Category>>> getCategories();
  
  /// Get trending videos
  Future<Either<Failure, List<Video>>> getTrendingVideos();
  
  /// Get recommended videos based on user preferences
  Future<Either<Failure, List<Video>>> getRecommendedVideos();
}
