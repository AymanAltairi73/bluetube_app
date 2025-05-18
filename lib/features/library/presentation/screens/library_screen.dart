import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/di/dependency_injection.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/widgets/bluetube_app_bar.dart';
import '../controllers/library_controller.dart';
import '../widgets/library_item_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller from dependency injection
    final controller = Get.put(sl<LibraryController>());

    return Scaffold(
      appBar: BlueTubeAppBar(
        title: 'Library',
        showLogo: false,
        profileImageUrl: 'assets/images/profile.png',
        onSearchTap: () {},
        actions: [
          IconButton(
            icon: const Icon(Icons.youtube_searched_for),
            onPressed: () => Get.toNamed(AppRoutes.youtubeSearch),
            tooltip: 'YouTube Search',
          ),
        ],
      ),
      body: Obx(() => _buildBody(controller)),
    );
  }

  Widget _buildBody(LibraryController controller) {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage.value != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.errorMessage.value!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: controller.refreshLibraryItems,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (controller.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library_outlined, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No items in your library',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            Text(
              'Videos you watch, like, or save will appear here',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.youtubeSearch),
              icon: const Icon(Icons.search),
              label: const Text('Search YouTube Videos'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshLibraryItems,
      child: ListView.builder(
        itemCount: controller.items.length,
        itemBuilder: (context, index) {
          final item = controller.items[index];
          return LibraryItemCard(
            item: item,
            onTap: () {
              // Navigate to video detail
            },
          );
        },
      ),
    );
  }
}
