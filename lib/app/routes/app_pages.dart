import 'package:get/get.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/shorts/presentation/screens/shorts_screen.dart';
import '../../features/subscription/presentation/screens/subscription_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/upload/presentation/screens/upload_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/video/presentation/screens/video_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/youtube_search/presentation/screens/youtube_search_screen.dart';
import '../../features/youtube_search/presentation/screens/youtube_video_player_screen.dart';
import '../../features/youtube_search/presentation/screens/watch_later_screen.dart';
import '../../features/youtube_search/presentation/screens/downloads_screen.dart';
import '../../features/auth/presentation/routes/auth_routes.dart';
import 'app_routes.dart';
import '../navigation/main_navigation.dart';

/// Application routes configuration
class AppPages {
  static final routes = [
    // Add authentication routes
    ...AuthRoutes.routes,
    GetPage(
      name: AppRoutes.main,
      page: () => const MainNavigation(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.shorts,
      page: () => const ShortsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.subscription,
      page: () => const SubscriptionScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.library,
      page: () => const LibraryScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.upload,
      page: () => const UploadScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.explore,
      page: () => const ExploreScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.video,
      page: () => const VideoScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.youtubeSearch,
      page: () => const YouTubeSearchScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.youtubeVideoPlayer,
      page: () => YouTubeVideoPlayerScreen(videoId: Get.parameters['videoId'] ?? ''),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.watchLater,
      page: () => const WatchLaterScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.downloads,
      page: () => const DownloadsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
