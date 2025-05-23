import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/signup_use_case.dart';
import '../../domain/usecases/social_login_use_case.dart';
import '../../utils/validation_utils.dart';

/// Controller for signup screen
class SignupController extends GetxController {
  final SignupUseCase signupUseCase;
  final SocialLoginUseCase socialLoginUseCase;

  SignupController({
    required this.signupUseCase,
    required this.socialLoginUseCase,
  });

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // State variables
  final RxBool isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool agreeToTerms = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  /// Toggle agree to terms
  void toggleAgreeToTerms() {
    agreeToTerms.value = !agreeToTerms.value;
  }

  /// Validate name
  String? validateName(String? value) {
    return ValidationUtils.validateName(value);
  }

  /// Validate email
  String? validateEmail(String? value) {
    return ValidationUtils.validateEmail(value);
  }

  /// Validate password
  String? validatePassword(String? value) {
    return ValidationUtils.validatePassword(value);
  }

  /// Validate confirm password
  String? validateConfirmPassword(String? value) {
    return ValidationUtils.validatePasswordConfirmation(
      value,
      passwordController.text,
    );
  }

  /// Signup with email and password
  Future<void> signup() async {
    // Clear previous error
    errorMessage.value = null;

    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Check if user agreed to terms
    if (!agreeToTerms.value) {
      errorMessage.value = 'You must agree to the Terms and Conditions';
      return;
    }

    isLoading.value = true;

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Use signup use case (mock implementation)
      final result = await signupUseCase.call(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      result.fold(
        (failure) {
          // Handle signup failure
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
  Future<void> signupWithGoogle() async {
    // Clear previous error
    errorMessage.value = null;

    // Check if user agreed to terms
    if (!agreeToTerms.value) {
      errorMessage.value = 'You must agree to the Terms and Conditions';
      return;
    }

    isLoading.value = true;

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Use social login use case (mock implementation)
      final result = await socialLoginUseCase.loginWithGoogle();

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

  /// Navigate to login screen
  void goToLogin() {
    Get.toNamed('/auth/login');
  }
}
