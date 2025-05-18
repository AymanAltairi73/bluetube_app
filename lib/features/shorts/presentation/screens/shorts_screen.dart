import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/di/dependency_injection.dart';
import '../controllers/shorts_controller.dart';
import '../widgets/short_video_player.dart';
import '../widgets/short_actions.dart';

class ShortsScreen extends StatelessWidget {
  const ShortsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller from dependency injection
    final controller = Get.put(sl<ShortsController>());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => _buildBody(controller)),
    );
  }

  Widget _buildBody(ShortsController controller) {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
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
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: controller.refreshShorts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (controller.shorts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, size: 64.sp, color: Colors.white),
            SizedBox(height: 16.h),
            Text(
              'No shorts available',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // PageView for swiping through shorts
        PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.shorts.length,
          onPageChanged: controller.changeShort,
          itemBuilder: (context, index) {
            final short = controller.shorts[index];
            return Stack(
              fit: StackFit.expand,
              children: [
                // Video player
                ShortVideoPlayer(
                  short: short,
                  autoPlay: index == controller.currentIndex.value,
                ),

                // Actions (like, comment, share, etc.)
                Positioned(
                  right: 0,
                  bottom: 80.h,
                  child: ShortActions(
                    short: short,
                    onLike: controller.likeCurrentShort,
                    onComment: () {
                      // Show comments
                      _showCommentsSheet(context, short);
                    },
                    onShare: () {
                      // Share short
                    },
                    onSubscribe: controller.subscribeToCurrentAuthor,
                  ),
                ),
              ],
            );
          },
        ),

        // Back button
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24.r,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCommentsSheet(BuildContext context, short) {
    Get.bottomSheet(
      Container(
        height: 500.h,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: short.comments,
                itemBuilder: (context, index) {
                  // Mock comments
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/channel_avatar.png'),
                    ),
                    title: Text('User ${index + 1}'),
                    subtitle: Text('This is a great short! I learned a lot.'),
                    trailing: Icon(Icons.thumb_up),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
