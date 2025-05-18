import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/social_login_button.dart';

/// Authentication selection screen
class AuthSelectionScreen extends StatefulWidget {
  const AuthSelectionScreen({super.key});

  @override
  State<AuthSelectionScreen> createState() => _AuthSelectionScreenState();
}

class _AuthSelectionScreenState extends State<AuthSelectionScreen> with SingleTickerProviderStateMixin {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.md.w),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),
                    
                    // App logo
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 80.w,
                        height: 80.h,
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // App name
                    Text(
                      'BlueTube',
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeXxl.sp,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? AppColors.textLight : AppColors.textPrimary,
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Welcome text
                    Text(
                      'Well come\nto best video app In World',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeLg.sp,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? AppColors.textLight : AppColors.textPrimary,
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // App description
                    Text(
                      'Rowse welcome text animations videos and find your perfect clip. Free HD & 4K videos. Royalty-free videos.Welcome, Channel, Message, InformationMissing: best | Show results with:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeSm.sp,
                        color: isDarkMode ? Colors.grey[300] : AppColors.textSecondary,
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Login button
                    AuthButton(
                      text: 'Log in',
                      onPressed: () => Get.toNamed('/login'),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Social login options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialLoginButton(
                          type: SocialLoginType.google,
                          onPressed: () => _authController.loginWithGoogle(),
                        ),
                        SizedBox(width: 16.w),
                        SocialLoginButton(
                          type: SocialLoginType.apple,
                          onPressed: () => _authController.loginWithApple(),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Sign up option
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
                          onPressed: () => Get.toNamed('/signup'),
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
                    
                    SizedBox(height: 16.h),
                    
                    // Continue as guest
                    TextButton(
                      onPressed: () => _authController.continueAsGuest(),
                      child: Text(
                        'Continue as Guest',
                        style: TextStyle(
                          fontSize: AppDimensions.fontSizeSm.sp,
                          color: isDarkMode ? Colors.grey[300] : AppColors.textSecondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
