import 'package:get/get.dart';
import '../../domain/entities/explore_category.dart';
import '../../domain/entities/explore_video.dart';
import '../../domain/usecases/get_explore_categories.dart';
import '../../domain/usecases/get_trending_videos.dart';
import '../../domain/usecases/get_videos_by_category.dart';

/// Controller for the Explore screen using GetX
class ExploreController extends GetxController {
  final GetExploreCategories getExploreCategories;
  final GetTrendingVideos getTrendingVideos;
  final GetVideosByCategory getVideosByCategory;
  
  ExploreController({
    required this.getExploreCategories,
    required this.getTrendingVideos,
    required this.getVideosByCategory,
  });
  
  // State variables using Rx
  final RxBool isCategoriesLoading = false.obs;
  final RxBool isVideosLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final RxList<ExploreCategory> categories = <ExploreCategory>[].obs;
  final RxList<ExploreVideo> trendingVideos = <ExploreVideo>[].obs;
  final RxMap<String, List<ExploreVideo>> categoryVideos = <String, List<ExploreVideo>>{}.obs;
  final RxString selectedCategoryId = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }
  
  /// Load initial data (categories and trending videos)
  Future<void> loadInitialData() async {
    await loadCategories();
    await loadTrendingVideos();
  }
  
  /// Load explore categories
  Future<void> loadCategories() async {
    isCategoriesLoading.value = true;
    
    final result = await getExploreCategories();
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isCategoriesLoading.value = false;
      },
      (categoriesList) {
        categories.assignAll(categoriesList);
        isCategoriesLoading.value = false;
        
        // If we have categories, load videos for the first category
        if (categoriesList.isNotEmpty) {
          selectedCategoryId.value = categoriesList.first.id;
          loadVideosByCategory(categoriesList.first.id);
        }
      },
    );
  }
  
  /// Load trending videos
  Future<void> loadTrendingVideos() async {
    isVideosLoading.value = true;
    errorMessage.value = null;
    
    final result = await getTrendingVideos();
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isVideosLoading.value = false;
      },
      (videosList) {
        trendingVideos.assignAll(videosList);
        isVideosLoading.value = false;
      },
    );
  }
  
  /// Load videos by category
  Future<void> loadVideosByCategory(String categoryId) async {
    // If we already have videos for this category, don't reload
    if (categoryVideos.containsKey(categoryId)) {
      selectedCategoryId.value = categoryId;
      return;
    }
    
    isVideosLoading.value = true;
    errorMessage.value = null;
    selectedCategoryId.value = categoryId;
    
    final result = await getVideosByCategory(categoryId);
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isVideosLoading.value = false;
      },
      (videosList) {
        categoryVideos[categoryId] = videosList;
        isVideosLoading.value = false;
      },
    );
  }
  
  /// Get videos for the selected category
  List<ExploreVideo> get selectedCategoryVideos {
    return categoryVideos[selectedCategoryId.value] ?? [];
  }
  
  /// Refresh explore data
  Future<void> refreshExploreData() async {
    return loadInitialData();
  }
}
