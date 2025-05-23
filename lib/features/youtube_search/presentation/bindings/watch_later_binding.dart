import 'package:get/get.dart';
import '../../../../app/di/dependency_injection.dart';
import '../controllers/watch_later_controller.dart';

/// Binding for watch later screen
class WatchLaterBinding extends Bindings {
  @override
  void dependencies() {
    // Get the WatchLaterController from the dependency injection container
    Get.put<WatchLaterController>(sl<WatchLaterController>());
  }
}
