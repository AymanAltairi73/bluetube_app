import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../utils/validation_utils.dart';

/// Controller for login screen
class LoginController extends GetxController {
  final LoginUseCase loginUseCase;

  LoginController({required this.loginUseCase});

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // State variables
  final RxBool isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final RxBool rememberMe = false.obs;
  final RxBool obscurePassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Toggle remember me
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  /// Validate email
  String? validateEmail(String? value) {
    return ValidationUtils.validateEmail(value);
  }

  /// Validate password
  String? validatePassword(String? value) {
    // For login, we'll use a simpler password validation
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Login with email and password
  Future<void> login() async {
    // Clear previous error
    errorMessage.value = null;

    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Use login use case (mock implementation)
      final result = await loginUseCase.call(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      result.fold(
        (failure) {
          // Handle login failure
          errorMessage.value = failure.message;
        },
        (authResponse) {
          // If successful, navigate to home screen
          Get.offAllNamed('/');
        },
      );
    } catch (e) {
      // Handle errors
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign in with Google
  Future<void> loginWithGoogle() async {
    // Clear previous error
    errorMessage.value = null;

    isLoading.value = true;

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful Google login
      Get.offAllNamed('/');
    } catch (e) {
      // Handle errors
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to forgot password screen
  void goToForgotPassword() {
    Get.toNamed('/auth/forgot-password');
  }

  /// Navigate to signup screen
  void goToSignup() {
    Get.toNamed('/auth/signup');
  }
}
