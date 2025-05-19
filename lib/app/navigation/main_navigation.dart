import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/subscription/presentation/screens/subscription_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/youtube_search/presentation/screens/downloads_screen.dart';
import '../routes/app_routes.dart';

/// Controller for the main navigation
class MainNavigationController extends GetxController {
  // Observable variables
  final RxInt selectedIndex = 0.obs;
  final RxBool isVideoPlayerActive = false.obs;
  final RxBool isFullScreenActive = false.obs;

  // Navigation history for back button handling
  final RxList<int> navigationHistory = <int>[0].obs;

  // Screens list
  final List<Widget> screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const SubscriptionScreen(),
    const LibraryScreen(),
    const DownloadsScreen(),
  ];

  // Screen routes for deep linking
  final List<String> screenRoutes = [
    AppRoutes.home,
    AppRoutes.explore,
    AppRoutes.subscription,
    AppRoutes.library,
    AppRoutes.downloads,
  ];

  // Change the selected tab
  void changeTab(int index) {
    // Don't add to history if selecting the same tab
    if (selectedIndex.value != index) {
      // Add current index to history before changing
      navigationHistory.add(selectedIndex.value);

      // Update the selected index
      selectedIndex.value = index;

      // Update route in GetX navigation system for deep linking support
      Get.offNamed(screenRoutes[index], preventDuplicates: false);
    }
  }

  // Handle back button press
  bool handleBackButton() {
    // If we're in a video player or fullscreen mode, handle differently
    if (isVideoPlayerActive.value || isFullScreenActive.value) {
      isVideoPlayerActive.value = false;
      isFullScreenActive.value = false;
      return true; // Prevent default back behavior
    }

    // If we have navigation history, go back to previous tab
    if (navigationHistory.length > 1) {
      // Get the previous index
      final previousIndex = navigationHistory.removeLast();

      // Update the selected index without adding to history
      selectedIndex.value = previousIndex;

      // Update route in GetX navigation system
      Get.offNamed(screenRoutes[previousIndex], preventDuplicates: false);

      return true; // Prevent default back behavior
    }

    return false; // Allow default back behavior (exit app)
  }

  // Set video player state
  void setVideoPlayerActive(bool active) {
    isVideoPlayerActive.value = active;
  }

  // Set fullscreen state
  void setFullScreenActive(bool active) {
    isFullScreenActive.value = active;
  }

  // Check if navigation bar should be hidden
  bool shouldHideNavBar() {
    return isVideoPlayerActive.value || isFullScreenActive.value;
  }
}

/// Main navigation widget with bottom navigation bar
class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(MainNavigationController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.screens,
        ),
        bottomNavigationBar: controller.shouldHideNavBar()
            ? null
            : Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.background,
                  selectedItemColor: isDarkMode ? AppColors.primaryLight : AppColors.primary,
                  unselectedItemColor: isDarkMode
                      ? AppColors.textLight.withValues(alpha: 0.7)
                      : AppColors.textSecondary,
                  selectedLabelStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12.sp,
                  ),
                  currentIndex: controller.selectedIndex.value,
                  elevation: 8,
                  onTap: controller.changeTab,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.explore_outlined),
                      activeIcon: Icon(Icons.explore),
                      label: 'Explore',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.subscriptions_outlined),
                      activeIcon: Icon(Icons.subscriptions),
                      label: 'Subscriptions',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.video_library_outlined),
                      activeIcon: Icon(Icons.video_library),
                      label: 'Library',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.download_outlined),
                      activeIcon: Icon(Icons.download),
                      label: 'Downloads',
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
