import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/validation_utils.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';

/// Sign up screen
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final AuthController _authController = Get.find<AuthController>();
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );
    
    // Clear any previous form data
    _authController.clearForms();
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? AppColors.textLight : AppColors.textPrimary,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.md.w),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Form(
                  key: _authController.signupFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 40.w,
                              height: 40.h,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            'BlueTube',
                            style: TextStyle(
                              fontSize: AppDimensions.fontSizeXxl.sp,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? AppColors.textLight : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 40.h),
                      
                      // Name field
                      AuthTextField(
                        hintText: 'Full Name',
                        prefixIcon: Icons.person_outline,
                        controller: _authController.nameController,
                        textInputAction: TextInputAction.next,
                        focusNode: _authController.nameFocusNode,
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_authController.emailFocusNode),
                        validator: ValidationUtils.validateName,
                      ),
                      
                      SizedBox(height: 16.h),
                      
                      // Email field
                      AuthTextField(
                        hintText: 'Enter Your Email',
                        prefixIcon: Icons.email_outlined,
                        controller: _authController.emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        focusNode: _authController.emailFocusNode,
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_authController.passwordFocusNode),
                        validator: ValidationUtils.validateEmail,
                      ),
                      
                      SizedBox(height: 16.h),
                      
                      // Password field
                      AuthTextField(
                        hintText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        controller: _authController.passwordController,
                        textInputAction: TextInputAction.next,
                        focusNode: _authController.passwordFocusNode,
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_authController.confirmPasswordFocusNode),
                        validator: ValidationUtils.validatePassword,
                      ),
                      
                      SizedBox(height: 16.h),
                      
                      // Confirm password field
                      AuthTextField(
                        hintText: 'Reset Password',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        controller: _authController.confirmPasswordController,
                        textInputAction: TextInputAction.done,
                        focusNode: _authController.confirmPasswordFocusNode,
                        onEditingComplete: () => _authController.signup(),
                        validator: (value) => ValidationUtils.validateConfirmPassword(
                          value,
                          _authController.passwordController.text,
                        ),
                      ),
                      
                      SizedBox(height: 16.h),
                      
                      // Terms and conditions
                      Row(
                        children: [
                          Obx(() => Checkbox(
                            value: _authController.acceptedTerms.value,
                            onChanged: (value) => _authController.toggleTermsAcceptance(),
                            activeColor: AppColors.primary,
                          )),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _authController.toggleTermsAcceptance(),
                              child: RichText(
                                text: TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                    fontSize: AppDimensions.fontSizeSm.sp,
                                    color: isDarkMode ? Colors.grey[300] : AppColors.textSecondary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 16.h),
                      
                      // Error message
                      Obx(() {
                        if (_authController.signupErrorMessage.isNotEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppDimensions.sm.w),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSm),
                            ),
                            child: Text(
                              _authController.signupErrorMessage.value,
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: AppDimensions.fontSizeSm.sp,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      
                      SizedBox(height: 24.h),
                      
                      // Register button
                      Obx(() => AuthButton(
                        text: 'Register',
                        isLoading: _authController.isSignupLoading.value,
                        onPressed: () => _authController.signup(),
                      )),
                      
                      SizedBox(height: 24.h),
                      
                      // Social login options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => SocialLoginButton(
                            type: SocialLoginType.google,
                            isLoading: _authController.isGoogleLoading.value,
                            onPressed: () => _authController.loginWithGoogle(),
                          )),
                          SizedBox(width: 16.w),
                          Obx(() => SocialLoginButton(
                            type: SocialLoginType.apple,
                            isLoading: _authController.isAppleLoading.value,
                            onPressed: () => _authController.loginWithApple(),
                          )),
                        ],
                      ),
                      
                      SizedBox(height: 24.h),
                      
                      // Login option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              fontSize: AppDimensions.fontSizeSm.sp,
                              color: isDarkMode ? Colors.grey[300] : AppColors.textSecondary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _authController.clearForms();
                              Get.offNamed('/login');
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: AppDimensions.fontSizeSm.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
