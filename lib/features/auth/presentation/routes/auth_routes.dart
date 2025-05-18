import 'package:get/get.dart';
import '../bindings/auth_binding.dart';
import '../screens/auth_selection_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

/// Routes for authentication screens
class AuthRoutes {
  static const String authSelection = '/auth';
  static const String login = '/login';
  static const String signup = '/signup';
  
  /// Get authentication routes
  static List<GetPage> routes = [
    GetPage(
      name: authSelection,
      page: () => const AuthSelectionScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signup,
      page: () => const SignupScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
