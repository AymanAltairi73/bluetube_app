import 'package:get/get.dart';
import '../../../../app/di/dependency_injection.dart';
import '../controllers/downloads_controller.dart';

/// Binding for downloads screen
class DownloadsBinding extends Bindings {
  @override
  void dependencies() {
    // Get the DownloadsController from the dependency injection container
    Get.put<DownloadsController>(sl<DownloadsController>());
  }
}
