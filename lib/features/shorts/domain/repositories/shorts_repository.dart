import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/short.dart';

/// Repository interface for shorts-related operations
abstract class ShortsRepository {
  /// Get all shorts
  Future<Either<Failure, List<Short>>> getShorts();
  
  /// Get shorts by author
  Future<Either<Failure, List<Short>>> getShortsByAuthor(String author);
  
  /// Like a short
  Future<Either<Failure, bool>> likeShort(String shortId);
  
  /// Unlike a short
  Future<Either<Failure, bool>> unlikeShort(String shortId);
  
  /// Subscribe to an author
  Future<Either<Failure, bool>> subscribeToAuthor(String author);
  
  /// Unsubscribe from an author
  Future<Either<Failure, bool>> unsubscribeFromAuthor(String author);
}
