import '../../../../core/errors/failures.dart';
import '../entities/library_item.dart';

/// Repository interface for library-related operations
abstract class LibraryRepository {
  /// Get all library items
  Future<Either<Failure, List<LibraryItem>>> getLibraryItems();
  
  /// Get library items by type
  Future<Either<Failure, List<LibraryItem>>> getLibraryItemsByType(LibraryItemType type);
  
  /// Add item to library
  Future<Either<Failure, bool>> addToLibrary(LibraryItem item);
  
  /// Remove item from library
  Future<Either<Failure, bool>> removeFromLibrary(String itemId);
}

/// Simple Either implementation for handling success or failure
class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool isRight;

  const Either._(this._left, this._right, this.isRight);

  factory Either.left(L value) => Either._(value, null, false);
  factory Either.right(R value) => Either._(null, value, true);

  L get left => _left as L;
  R get right => _right as R;

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    return isRight ? onRight(_right as R) : onLeft(_left as L);
  }
}
