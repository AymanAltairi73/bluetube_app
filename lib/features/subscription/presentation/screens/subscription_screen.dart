import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/di/dependency_injection.dart';
import '../../../../core/widgets/bluetube_app_bar.dart';
import '../controllers/subscription_controller.dart';
import '../widgets/channel_avatar_row.dart';
import '../widgets/subscription_filter_row.dart';
import '../widgets/subscription_video_card.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller from dependency injection
    final controller = Get.put(sl<SubscriptionController>());

    return Scaffold(
      appBar: BlueTubeAppBar(
        showLogo: true,
        profileImageUrl: 'assets/images/profile.png',
        onSearchTap: () {},
        onNotificationTap: () {},
        onCastTap: () {},
        onProfileTap: () {},
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshSubscriptionData,
        child: Column(
          children: [
            // Channels row
            Obx(() => _buildChannelsSection(controller)),

            // Filters row
            Obx(() => _buildFiltersSection(controller)),

            // Videos
            Expanded(
              child: Obx(() => _buildVideosSection(controller)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelsSection(SubscriptionController controller) {
    if (controller.isChannelsLoading.value) {
      return SizedBox(
        height: 100.h,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller.channels.isEmpty) {
      return SizedBox(
        height: 100.h,
        child: Center(
          child: Text(
            'No subscribed channels',
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      );
    }

    return ChannelAvatarRow(
      channels: controller.channels,
      onChannelTap: (channel) {
        // Navigate to channel detail
      },
    );
  }

  Widget _buildFiltersSection(SubscriptionController controller) {
    if (controller.isFiltersLoading.value) {
      return SizedBox(
        height: 50.h,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller.filters.isEmpty) {
      return SizedBox(
        height: 50.h,
        child: Center(
          child: Text(
            'No filters available',
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      );
    }

    return SubscriptionFilterRow(
      filters: controller.filters,
      onFilterTap: controller.loadVideosByFilter,
    );
  }

  Widget _buildVideosSection(SubscriptionController controller) {
    if (controller.isVideosLoading.value) {
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
              onPressed: controller.refreshSubscriptionData,
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
              'Subscribe to channels to see their latest videos',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Check if we have shorts to display
    final hasShorts = controller.videos.any((video) => video.isShort);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shorts section (if any)
          if (hasShorts) ...[
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Text(
                'Shorts',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 300.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.videos.where((video) => video.isShort).length,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                itemBuilder: (context, index) {
                  final short = controller.videos.where((video) => video.isShort).toList()[index];
                  return SubscriptionVideoCard(
                    video: short,
                    onTap: () {
                      // Navigate to shorts player
                    },
                  );
                },
              ),
            ),
            Divider(height: 32.h),
          ],

          // Regular videos
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.videos.where((video) => !video.isShort).length,
            itemBuilder: (context, index) {
              final video = controller.videos.where((video) => !video.isShort).toList()[index];
              return SubscriptionVideoCard(
                video: video,
                onTap: () {
                  // Navigate to video player
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
