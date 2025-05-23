import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/forgot_password_use_case.dart';
import '../../utils/validation_utils.dart';

/// Controller for forgot password screen
class ForgotPasswordController extends GetxController {
  final ForgotPasswordUseCase forgotPasswordUseCase;

  ForgotPasswordController({required this.forgotPasswordUseCase});

  // Form controllers
  final emailController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // State variables
  final RxBool isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final RxBool isEmailSent = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  /// Validate email
  String? validateEmail(String? value) {
    return ValidationUtils.validateEmail(value);
  }

  /// Send password reset email
  Future<void> sendResetEmail() async {
    // Clear previous error
    errorMessage.value = null;
    
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    isLoading.value = true;
    
    final result = await forgotPasswordUseCase(emailController.text.trim());
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (success) {
        isLoading.value = false;
        isEmailSent.value = true;
      },
    );
  }

  /// Navigate back to login screen
  void goToLogin() {
    Get.back();
  }
}
