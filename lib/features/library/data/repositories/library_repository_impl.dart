import '../../../../core/errors/failures.dart';
import '../../domain/entities/library_item.dart';
import '../../domain/repositories/library_repository.dart';
import '../datasources/library_local_data_source.dart';
import '../models/library_item_model.dart';

/// Implementation of [LibraryRepository]
class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryLocalDataSource localDataSource;

  LibraryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<LibraryItem>>> getLibraryItems() async {
    try {
      final items = await localDataSource.getLibraryItems();
      return Either.right(items);
    } on CacheFailure catch (e) {
      return Either.left(e);
    } catch (e) {
      return Either.left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<LibraryItem>>> getLibraryItemsByType(
      LibraryItemType type) async {
    try {
      final typeString = _mapTypeToString(type);
      final items = await localDataSource.getLibraryItemsByType(typeString);
      return Either.right(items);
    } on CacheFailure catch (e) {
      return Either.left(e);
    } catch (e) {
      return Either.left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> addToLibrary(LibraryItem item) async {
    try {
      final itemModel = LibraryItemModel(
        id: item.id,
        title: item.title,
        thumbnailUrl: item.thumbnailUrl,
        channelName: item.channelName,
        createdAt: item.createdAt,
        type: item.type,
      );
      
      final result = await localDataSource.addToLibrary(itemModel);
      return Either.right(result);
    } on CacheFailure catch (e) {
      return Either.left(e);
    } catch (e) {
      return Either.left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromLibrary(String itemId) async {
    try {
      final result = await localDataSource.removeFromLibrary(itemId);
      return Either.right(result);
    } on CacheFailure catch (e) {
      return Either.left(e);
    } catch (e) {
      return Either.left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  /// Map LibraryItemType enum to string
  String _mapTypeToString(LibraryItemType type) {
    switch (type) {
      case LibraryItemType.watchLater:
        return 'watch_later';
      case LibraryItemType.history:
        return 'history';
      case LibraryItemType.playlist:
        return 'playlist';
      case LibraryItemType.likedVideo:
        return 'liked_video';
      case LibraryItemType.savedVideo:
        return 'saved_video';
    }
  }
}
