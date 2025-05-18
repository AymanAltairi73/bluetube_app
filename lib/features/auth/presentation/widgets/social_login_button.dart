import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/animations/auth_animation_utils.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Social login button types
enum SocialLoginType {
  google,
  apple,
  facebook,
  twitter,
}

/// Button for social login options
class SocialLoginButton extends StatefulWidget {
  final SocialLoginType type;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AuthAnimationUtils.quickDuration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AuthAnimationUtils.standardCurve,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isLoading) {
          _animationController.forward();
        }
      },
      onTapUp: (_) {
        if (!widget.isLoading) {
          _animationController.reverse();
        }
      },
      onTapCancel: () {
        if (!widget.isLoading) {
          _animationController.reverse();
        }
      },
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: widget.isLoading
                  ? Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Center(
                      child: _buildIcon(),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon() {
    switch (widget.type) {
      case SocialLoginType.google:
        return Image.asset(
          'assets/images/google_logo.png',
          width: 24.w,
          height: 24.w,
        );
      case SocialLoginType.apple:
        return Icon(
          Icons.apple,
          size: 28.sp,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        );
      case SocialLoginType.facebook:
        return Icon(
          Icons.facebook,
          size: 28.sp,
          color: const Color(0xFF1877F2),
        );
      case SocialLoginType.twitter:
        return Icon(
          Icons.flutter_dash,
          size: 28.sp,
          color: const Color(0xFF1DA1F2),
        );
    }
  }
}
