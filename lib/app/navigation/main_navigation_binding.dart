import 'package:get/get.dart';
import '../../app/di/dependency_injection.dart';
import '../../features/youtube_search/presentation/controllers/downloads_controller.dart';
import '../../features/youtube_search/presentation/controllers/watch_later_controller.dart';
import '../../features/youtube_search/presentation/controllers/youtube_search_controller.dart';
import '../../features/home/presentation/controllers/home_controller.dart';
import '../../features/explore/presentation/controllers/explore_controller.dart';
import '../../features/subscription/presentation/controllers/subscription_controller.dart';
import '../../features/library/presentation/controllers/library_controller.dart';
import 'main_navigation.dart';

/// Binding for main navigation
class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Main navigation controller
    Get.put<MainNavigationController>(MainNavigationController());
    
    // Initialize all controllers needed for the main screens
    Get.put<HomeController>(sl<HomeController>());
    Get.put<ExploreController>(sl<ExploreController>());
    Get.put<SubscriptionController>(sl<SubscriptionController>());
    Get.put<LibraryController>(sl<LibraryController>());
    
    // Initialize YouTube search related controllers
    Get.put<YouTubeSearchController>(sl<YouTubeSearchController>());
    Get.put<WatchLaterController>(sl<WatchLaterController>());
    Get.put<DownloadsController>(sl<DownloadsController>(), permanent: true);
  }
}
