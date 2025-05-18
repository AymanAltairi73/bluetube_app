import 'package:get/get.dart';
import '../../domain/entities/video.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_videos.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_videos_by_category.dart';

/// Controller for the Home screen using GetX
class HomeController extends GetxController {
  final GetVideos getVideos;
  final GetCategories getCategories;
  final GetVideosByCategory getVideosByCategory;
  
  HomeController({
    required this.getVideos,
    required this.getCategories,
    required this.getVideosByCategory,
  });
  
  // State variables using Rx
  final RxBool isLoading = false.obs;
  final RxBool isCategoryLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final RxList<Video> videos = <Video>[].obs;
  final RxList<Category> categories = <Category>[].obs;
  final RxString selectedCategory = 'All'.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }
  
  /// Load initial data (categories and videos)
  Future<void> loadInitialData() async {
    await loadCategories();
    await loadVideos();
  }
  
  /// Load categories
  Future<void> loadCategories() async {
    isCategoryLoading.value = true;
    
    final result = await getCategories();
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isCategoryLoading.value = false;
      },
      (categoriesList) {
        categories.assignAll(categoriesList);
        isCategoryLoading.value = false;
      },
    );
  }
  
  /// Load videos
  Future<void> loadVideos() async {
    isLoading.value = true;
    errorMessage.value = null;
    
    final result = await getVideos();
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (videosList) {
        videos.assignAll(videosList);
        isLoading.value = false;
      },
    );
  }
  
  /// Load videos by category
  Future<void> loadVideosByCategory(String category) async {
    isLoading.value = true;
    errorMessage.value = null;
    selectedCategory.value = category;
    
    // Update selected category in the list
    final updatedCategories = categories.map((cat) {
      return cat.copyWith(isSelected: cat.name == category);
    }).toList();
    categories.assignAll(updatedCategories);
    
    final result = await getVideosByCategory(category);
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (videosList) {
        videos.assignAll(videosList);
        isLoading.value = false;
      },
    );
  }
  
  /// Refresh videos
  Future<void> refreshVideos() async {
    if (selectedCategory.value == 'All') {
      return loadVideos();
    } else {
      return loadVideosByCategory(selectedCategory.value);
    }
  }
}
