import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/navigation/navigation_service.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../domain/repositories/auth_repository.dart';

/// Controller for authentication screens
class AuthController extends GetxController {
  // Dependencies
  final NavigationService _navigationService = Get.find<NavigationService>();
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository}) : _authRepository = authRepository;
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
  final RxBool isFacebookLoading = false.obs;
  final RxBool isForgotPasswordLoading = false.obs;

  // Error messages
  final RxString loginErrorMessage = ''.obs;
  final RxString signupErrorMessage = ''.obs;
  final RxString forgotPasswordMessage = ''.obs;

  // Terms and conditions checkbox
  final RxBool acceptedTerms = false.obs;

  // Authentication status
  final RxBool isLoggedIn = false.obs;

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

    // Check if form key is valid
    if (loginFormKey.currentState == null) {
      loginErrorMessage.value = 'Form is not initialized';
      return false;
    }

    return loginFormKey.currentState!.validate();
  }

  /// Validate signup form
  bool validateSignupForm() {
    signupErrorMessage.value = '';

    // Check terms and conditions
    if (!acceptedTerms.value) {
      signupErrorMessage.value = 'You must accept the Terms and Conditions';
      return false;
    }

    // Check if form key is valid
    if (signupFormKey.currentState == null) {
      signupErrorMessage.value = 'Form is not initialized';
      return false;
    }

    return signupFormKey.currentState!.validate();
  }

  /// Login with email and password
  Future<void> login() async {
    // Check if controllers are disposed
    if (_isControllerDisposed(emailController) || _isControllerDisposed(passwordController)) {
      loginErrorMessage.value = 'Unable to access form fields';
      return;
    }

    if (!validateLoginForm()) return;

    isLoginLoading.value = true;

    try {
      // Use repository to login
      final result = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      result.fold(
        (failure) {
          // Handle login failure
          loginErrorMessage.value = failure.message;
        },
        (authResponse) {
          // Handle successful login
          _navigationService.navigateToMain();
        },
      );
    } catch (e) {
      loginErrorMessage.value = 'Login failed: ${e.toString()}';
    } finally {
      isLoginLoading.value = false;
    }
  }

  /// Sign up with email and password
  Future<void> signup() async {
    // Check if controllers are disposed
    if (_isControllerDisposed(emailController) ||
        _isControllerDisposed(passwordController) ||
        _isControllerDisposed(confirmPasswordController) ||
        _isControllerDisposed(nameController)) {
      signupErrorMessage.value = 'Unable to access form fields';
      return;
    }

    if (!validateSignupForm()) return;

    isSignupLoading.value = true;

    try {
      // Use repository to signup
      final result = await _authRepository.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      result.fold(
        (failure) {
          // Handle signup failure
          signupErrorMessage.value = failure.message;
        },
        (authResponse) {
          // Handle successful signup
          _navigationService.navigateToMain();
        },
      );
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
      // Use repository to login with Google
      final result = await _authRepository.loginWithGoogle();

      result.fold(
        (failure) {
          // Handle login failure
          loginErrorMessage.value = failure.message;
        },
        (authResponse) {
          // Handle successful login
          _navigationService.navigateToMain();
        },
      );
    } catch (e) {
      loginErrorMessage.value = 'Google login failed: ${e.toString()}';
    } finally {
      isGoogleLoading.value = false;
    }
  }

  /// Login with Facebook
  Future<void> loginWithFacebook() async {
    isFacebookLoading.value = true;

    try {
      // Facebook login is not implemented as per requirements
      loginErrorMessage.value = 'Facebook login is not implemented';
    } finally {
      isFacebookLoading.value = false;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail() async {
    // Check if controller is disposed
    if (_isControllerDisposed(emailController)) {
      forgotPasswordMessage.value = 'Unable to access email field';
      return;
    }

    if (emailController.text.isEmpty) {
      forgotPasswordMessage.value = 'Please enter your email address';
      return;
    }

    if (ValidationUtils.validateEmail(emailController.text) != null) {
      forgotPasswordMessage.value = 'Please enter a valid email address';
      return;
    }

    isForgotPasswordLoading.value = true;

    // Store email in a local variable to avoid accessing the controller later
    final email = emailController.text.trim();

    try {
      // Use repository to send password reset email
      final result = await _authRepository.forgotPassword(email);

      result.fold(
        (failure) {
          // Handle failure
          forgotPasswordMessage.value = failure.message;
        },
        (success) {
          // Handle success
          forgotPasswordMessage.value = 'Password reset email sent to $email';
          Get.snackbar(
            'Success',
            'Password reset email sent',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } catch (e) {
      forgotPasswordMessage.value = 'Failed to send reset email: ${e.toString()}';
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }

  /// Continue as guest
  void continueAsGuest() {
    _navigationService.navigateToMain();
  }

  /// Toggle terms and conditions acceptance
  void toggleTermsAcceptance() {
    acceptedTerms.value = !acceptedTerms.value;
  }

  /// Clear all form fields
  void clearForms() {
    try {
      // Use a safer approach to check if controllers are disposed
      if (!_isControllerDisposed(emailController)) emailController.clear();
      if (!_isControllerDisposed(passwordController)) passwordController.clear();
      if (!_isControllerDisposed(confirmPasswordController)) confirmPasswordController.clear();
      if (!_isControllerDisposed(nameController)) nameController.clear();

      acceptedTerms.value = false;
      loginErrorMessage.value = '';
      signupErrorMessage.value = '';
      forgotPasswordMessage.value = '';
    } catch (e) {
      // Handle the case where controllers might have been disposed
      debugPrint('Error clearing forms: ${e.toString()}');
    }
  }

  // Helper method to check if a controller is disposed
  bool _isControllerDisposed(TextEditingController controller) {
    try {
      // Accessing controller.text will throw if controller is disposed
      controller.text;
      return false; // If no exception, controller is not disposed
    } catch (e) {
      return true; // If exception, controller is disposed
    }
  }

  /// Check authentication status
  Future<void> checkAuthStatus() async {
    try {
      // Use repository to check if user is logged in
      final result = await _authRepository.isLoggedIn();

      result.fold(
        (failure) {
          // Handle failure
          isLoggedIn.value = false;
        },
        (loggedIn) {
          // Set login status
          isLoggedIn.value = loggedIn;
        },
      );
    } catch (e) {
      isLoggedIn.value = false;
    }
  }
}
