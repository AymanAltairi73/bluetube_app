import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

/// Main application widget
class BlueTubeApp extends StatelessWidget {
  const BlueTubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize GetStorage for theme persistence
    final themeController = Get.put(ThemeController());

    // Initialize ScreenUtil with design size of 375x812 (iPhone X)
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          initialRoute: AppRoutes.splash, // Start with splash screen to check authentication
          getPages: AppPages.routes,
          defaultTransition: Transition.fade,
        );
      },
    );
  }
}
