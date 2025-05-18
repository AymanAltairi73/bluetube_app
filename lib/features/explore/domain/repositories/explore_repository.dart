import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/explore_category.dart';
import '../entities/explore_video.dart';

/// Repository interface for explore-related operations
abstract class ExploreRepository {
  /// Get all explore categories
  Future<Either<Failure, List<ExploreCategory>>> getExploreCategories();
  
  /// Get trending videos
  Future<Either<Failure, List<ExploreVideo>>> getTrendingVideos();
  
  /// Get videos by category
  Future<Either<Failure, List<ExploreVideo>>> getVideosByCategory(String categoryId);
}
