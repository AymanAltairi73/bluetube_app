import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

/// Auth view screen that switches between login and signup
class AuthViewScreen extends StatefulWidget {
  const AuthViewScreen({super.key});

  @override
  State<AuthViewScreen> createState() => _AuthViewScreenState();
}

class _AuthViewScreenState extends State<AuthViewScreen> {
  final PageController _pageController = PageController();
  final RxInt _currentPage = 0.obs;

  // Get controller
  final _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _currentPage.value = index;
          // Clear form data when switching pages
          if (index == 0) {
            _authController.signupErrorMessage.value = '';
          } else {
            _authController.loginErrorMessage.value = '';
          }
        },
        children: [
          // Login page
          const LoginScreen(),

          // Signup page
          const SignupScreen(),
        ],
      ),
    );
  }
}
