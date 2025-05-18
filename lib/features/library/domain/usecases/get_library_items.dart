import '../../../../core/errors/failures.dart';
import '../entities/library_item.dart';
import '../repositories/library_repository.dart';

/// Use case for getting all library items
class GetLibraryItems {
  final LibraryRepository repository;

  GetLibraryItems(this.repository);

  Future<Either<Failure, List<LibraryItem>>> call() async {
    return await repository.getLibraryItems();
  }
}
