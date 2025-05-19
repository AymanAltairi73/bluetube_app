import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/di/dependency_injection.dart';
import '../../../../app/navigation/navigation_service.dart';
import '../../../../core/widgets/bluetube_app_bar.dart';
import '../controllers/explore_controller.dart';
import '../widgets/explore_category_card.dart';
import '../widgets/explore_video_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller from dependency injection
    final controller = Get.put(sl<ExploreController>());

    return Scaffold(
      appBar: BlueTubeAppBar(
        title: 'Explore',
        showLogo: false,
        profileImageUrl: 'assets/images/profile.png',
        onSearchTap: () {},
        onNotificationTap: () {},
        onCastTap: () {},
        onProfileTap: () {},
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshExploreData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categories grid
              Obx(() => _buildCategoriesSection(controller)),

              // Trending videos section
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Text(
                  'Trending',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Obx(() => _buildTrendingVideosSection(controller)),

              // Selected category videos section
              Obx(() {
                if (controller.selectedCategoryId.isNotEmpty) {
                  final categoryName = controller.categories
                      .firstWhere(
                        (cat) => cat.id == controller.selectedCategoryId.value,
                        orElse: () => controller.categories.first,
                      )
                      .title;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildCategoryVideosSection(controller),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(ExploreController controller) {
    if (controller.isCategoriesLoading.value) {
      return SizedBox(
        height: 200.h,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller.categories.isEmpty) {
      return SizedBox(
        height: 200.h,
        child: Center(
          child: Text(
            'No categories available',
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      padding: EdgeInsets.all(16.r),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.categories.length,
      itemBuilder: (context, index) {
        final category = controller.categories[index];
        return ExploreCategoryCard(
          category: category,
          onTap: () => controller.loadVideosByCategory(category.id),
        );
      },
    );
  }

  Widget _buildTrendingVideosSection(ExploreController controller) {
    final navigationService = Get.find<NavigationService>();
    if (controller.isVideosLoading.value) {
      return SizedBox(
        height: 300.h,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller.errorMessage.value != null) {
      return SizedBox(
        height: 300.h,
        child: Center(
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
                onPressed: controller.refreshExploreData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.trendingVideos.isEmpty) {
      return SizedBox(
        height: 300.h,
        child: Center(
          child: Text(
            'No trending videos available',
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: controller.trendingVideos.length,
      itemBuilder: (context, index) {
        final video = controller.trendingVideos[index];
        return ExploreVideoCard(
          video: video,
          onTap: () {
            // Navigate to video player
            navigationService.navigateToVideoPlayer(video.id);
          },
        );
      },
    );
  }

  Widget _buildCategoryVideosSection(ExploreController controller) {
    final navigationService = Get.find<NavigationService>();
    if (controller.isVideosLoading.value) {
      return SizedBox(
        height: 300.h,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller.selectedCategoryVideos.isEmpty) {
      return SizedBox(
        height: 300.h,
        child: Center(
          child: Text(
            'No videos available for this category',
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: controller.selectedCategoryVideos.length,
      itemBuilder: (context, index) {
        final video = controller.selectedCategoryVideos[index];
        return ExploreVideoCard(
          video: video,
          isHorizontal: true,
          onTap: () {
            // Navigate to video player
            navigationService.navigateToVideoPlayer(video.id);
          },
        );
      },
    );
  }
}
