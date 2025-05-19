import 'package:get/get.dart';
import '../routes/app_routes.dart';

/// Service to handle navigation between screens
class NavigationService extends GetxService {
  // Observable variables
  final RxBool isVideoPlayerActive = false.obs;
  final RxBool isFullScreenActive = false.obs;
  final RxBool isAuthenticated = false.obs;

  /// Initialize the service
  Future<NavigationService> init() async {
    // Check if user is authenticated (could be from local storage)
    // For now, we'll just set it to false
    isAuthenticated.value = false;
    return this;
  }

  /// Navigate to the main screen
  void navigateToMain() {
    Get.offAllNamed(AppRoutes.main);
  }

  /// Navigate to the auth screen
  void navigateToAuth() {
    Get.offAllNamed(AppRoutes.auth);
  }

  /// Navigate to the home screen
  void navigateToHome() {
    Get.toNamed(AppRoutes.home);
  }

  /// Navigate to the explore screen
  void navigateToExplore() {
    Get.toNamed(AppRoutes.explore);
  }

  /// Navigate to the subscription screen
  void navigateToSubscription() {
    Get.toNamed(AppRoutes.subscription);
  }

  /// Navigate to the library screen
  void navigateToLibrary() {
    Get.toNamed(AppRoutes.library);
  }

  /// Navigate to the downloads screen
  void navigateToDownloads() {
    Get.toNamed(AppRoutes.downloads);
  }

  /// Navigate to the search screen
  void navigateToSearch() {
    Get.toNamed(AppRoutes.youtubeSearch);
  }

  /// Navigate to the video player screen
  void navigateToVideoPlayer(String videoId) {
    isVideoPlayerActive.value = true;
    Get.toNamed(
      AppRoutes.youtubeVideoPlayer,
      parameters: {'videoId': videoId},
    );
  }

  /// Set fullscreen state
  void setFullScreenActive(bool active) {
    isFullScreenActive.value = active;
  }

  /// Check if navigation bar should be hidden
  bool shouldHideNavBar() {
    return isVideoPlayerActive.value || isFullScreenActive.value;
  }

  /// Handle back from video player
  void handleBackFromVideoPlayer() {
    isVideoPlayerActive.value = false;
    Get.back();
  }
}
