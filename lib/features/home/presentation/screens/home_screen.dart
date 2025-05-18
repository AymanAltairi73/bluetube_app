import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/di/dependency_injection.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/widgets/bluetube_app_bar.dart';
import '../controllers/home_controller.dart';
import '../widgets/category_chip.dart';
import '../widgets/video_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller from dependency injection
    final controller = Get.put(sl<HomeController>());

    return Scaffold(
      appBar: BlueTubeAppBar(
        showLogo: true,
        profileImageUrl: 'assets/images/profile.png',
        notificationCount: 1,
        onSearchTap: () {},
        onNotificationTap: () {},
        onCastTap: () {},
        onSettingsTap: () => Get.toNamed(AppRoutes.settings),
        onProfileTap: () {},
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshVideos,
        child: Column(
          children: [
            // Categories
            _buildCategoriesSection(controller),

            // Videos
            Expanded(
              child: _buildVideosSection(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(HomeController controller) {
    return Obx(() {
      if (controller.isCategoryLoading.value) {
        return SizedBox(
          height: 50.h,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return CategoryChip(
              category: category,
              onTap: () => controller.loadVideosByCategory(category.name),
            );
          },
        ),
      );
    });
  }

  Widget _buildVideosSection(HomeController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
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
                onPressed: controller.refreshVideos,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.videos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam_off, size: 64.sp, color: Colors.grey),
              SizedBox(height: 16.h),
              Text(
                'No videos available',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              Text(
                'Try selecting a different category',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.videos.length,
        itemBuilder: (context, index) {
          final video = controller.videos[index];
          return VideoCard(
            video: video,
            onTap: () {
              // Navigate to video screen
              Get.toNamed(AppRoutes.video, arguments: video.id);
            },
          );
        },
      );
    });
  }
}
