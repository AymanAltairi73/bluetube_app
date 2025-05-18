import 'package:get/get.dart';
import '../../domain/entities/library_item.dart';
import '../../domain/usecases/get_library_items.dart';

/// Controller for the Library screen using GetX
class LibraryController extends GetxController {
  final GetLibraryItems getLibraryItems;

  LibraryController({required this.getLibraryItems});

  // State variables using Rx
  final RxBool isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final RxList<LibraryItem> items = <LibraryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLibraryItems();
  }

  /// Load library items
  Future<void> loadLibraryItems() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await getLibraryItems();

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (libraryItems) {
        items.assignAll(libraryItems);
        isLoading.value = false;
      },
    );
  }

  /// Refresh library items
  Future<void> refreshLibraryItems() async {
    return loadLibraryItems();
  }
}
