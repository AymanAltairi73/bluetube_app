import 'package:get/get.dart';
import '../../../../app/di/dependency_injection.dart';
import '../controllers/youtube_search_controller.dart';

/// Binding for YouTube search screen
class YouTubeSearchBinding extends Bindings {
  @override
  void dependencies() {
    // Get the YouTubeSearchController from the dependency injection container
    Get.put<YouTubeSearchController>(sl<YouTubeSearchController>());
  }
}
