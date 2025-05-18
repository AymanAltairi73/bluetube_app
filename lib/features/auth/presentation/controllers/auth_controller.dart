import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/validation_utils.dart';

/// Controller for authentication screens
class AuthController extends GetxController {
  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  
  // Focus nodes
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  
  // Loading states
  final RxBool isLoginLoading = false.obs;
  final RxBool isSignupLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;
  final RxBool isAppleLoading = false.obs;
  final RxBool isForgotPasswordLoading = false.obs;
  
  // Error messages
  final RxString loginErrorMessage = ''.obs;
  final RxString signupErrorMessage = ''.obs;
  final RxString forgotPasswordMessage = ''.obs;
  
  // Terms and conditions checkbox
  final RxBool acceptedTerms = false.obs;
  
  @override
  void onClose() {
    // Dispose controllers
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    
    // Dispose focus nodes
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    nameFocusNode.dispose();
    
    super.onClose();
  }
  
  /// Validate login form
  bool validateLoginForm() {
    loginErrorMessage.value = '';
    return loginFormKey.currentState?.validate() ?? false;
  }
  
  /// Validate signup form
  bool validateSignupForm() {
    signupErrorMessage.value = '';
    
    // Check terms and conditions
    if (!acceptedTerms.value) {
      signupErrorMessage.value = 'You must accept the Terms and Conditions';
      return false;
    }
    
    return signupFormKey.currentState?.validate() ?? false;
  }
  
  /// Login with email and password
  Future<void> login() async {
    if (!validateLoginForm()) return;
    
    isLoginLoading.value = true;
    
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful login
      Get.offAllNamed('/home');
    } catch (e) {
      loginErrorMessage.value = 'Login failed: ${e.toString()}';
    } finally {
      isLoginLoading.value = false;
    }
  }
  
  /// Sign up with email and password
  Future<void> signup() async {
    if (!validateSignupForm()) return;
    
    isSignupLoading.value = true;
    
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful signup
      Get.offAllNamed('/home');
    } catch (e) {
      signupErrorMessage.value = 'Signup failed: ${e.toString()}';
    } finally {
      isSignupLoading.value = false;
    }
  }
  
  /// Login with Google
  Future<void> loginWithGoogle() async {
    isGoogleLoading.value = true;
    
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful login
      Get.offAllNamed('/home');
    } catch (e) {
      loginErrorMessage.value = 'Google login failed: ${e.toString()}';
    } finally {
      isGoogleLoading.value = false;
    }
  }
  
  /// Login with Apple
  Future<void> loginWithApple() async {
    isAppleLoading.value = true;
    
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful login
      Get.offAllNamed('/home');
    } catch (e) {
      loginErrorMessage.value = 'Apple login failed: ${e.toString()}';
    } finally {
      isAppleLoading.value = false;
    }
  }
  
  /// Send password reset email
  Future<void> sendPasswordResetEmail() async {
    if (emailController.text.isEmpty) {
      forgotPasswordMessage.value = 'Please enter your email address';
      return;
    }
    
    if (ValidationUtils.validateEmail(emailController.text) != null) {
      forgotPasswordMessage.value = 'Please enter a valid email address';
      return;
    }
    
    isForgotPasswordLoading.value = true;
    
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful password reset
      forgotPasswordMessage.value = 'Password reset email sent to ${emailController.text}';
      Get.snackbar(
        'Success',
        'Password reset email sent',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      forgotPasswordMessage.value = 'Failed to send reset email: ${e.toString()}';
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }
  
  /// Continue as guest
  void continueAsGuest() {
    Get.offAllNamed('/home');
  }
  
  /// Toggle terms and conditions acceptance
  void toggleTermsAcceptance() {
    acceptedTerms.value = !acceptedTerms.value;
  }
  
  /// Clear all form fields
  void clearForms() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    acceptedTerms.value = false;
    loginErrorMessage.value = '';
    signupErrorMessage.value = '';
    forgotPasswordMessage.value = '';
  }
}
