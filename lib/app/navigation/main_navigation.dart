import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/shorts/presentation/screens/shorts_screen.dart';
import '../../features/subscription/presentation/screens/subscription_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/upload/presentation/screens/upload_screen.dart';
import '../routes/app_routes.dart';

/// Controller for the main navigation
class MainNavigationController extends GetxController {
  // Observable variables
  final RxInt selectedIndex = 0.obs;

  // Screens list
  final List<Widget> screens = [
    const HomeScreen(),
    const ShortsScreen(),
    const UploadScreen(),
    const SubscriptionScreen(),
    const LibraryScreen(),
  ];

  // Computed property for whether we're on the shorts screen
  bool get isShortScreen => selectedIndex.value == 1;

  // Change the selected tab
  void changeTab(int index) {
    if (index == 2) {
      showUploadOptions();
      return;
    }

    selectedIndex.value = index;
  }

  // Show upload options
  void showUploadOptions() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Create a video'),
              onTap: () {
                Get.back();
                // Navigate to video creation
                Get.toNamed(AppRoutes.upload);
              },
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Create a Short'),
              onTap: () {
                Get.back();
                // Navigate to Short creation
                Get.toNamed(AppRoutes.shorts);
              },
            ),
            ListTile(
              leading: const Icon(Icons.live_tv),
              title: const Text('Go live'),
              onTap: () {
                Get.back();
                // Navigate to live streaming
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Main navigation widget with bottom navigation bar
class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(MainNavigationController());

    return Obx(() => Scaffold(
      body: controller.screens[controller.selectedIndex.value],
      bottomNavigationBar: controller.isShortScreen
          ? null
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              currentIndex: controller.selectedIndex.value,
              onTap: controller.changeTab,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.play_circle_outline),
                  label: 'Shorts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline, size: 40),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.subscriptions_outlined),
                  label: 'Subscription',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_library_outlined),
                  label: 'Library',
                ),
              ],
            ),
    ));
  }
}
