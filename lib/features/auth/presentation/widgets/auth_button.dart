import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/animations/auth_animation_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Custom button for authentication screens
class AuthButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const AuthButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> with SingleTickerProviderStateMixin {
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

    // Determine colors based on primary/secondary and theme
    final Color bgColor = widget.backgroundColor ??
        (widget.isPrimary
            ? AppColors.primary
            : (isDarkMode ? Colors.grey[800]! : Colors.grey[200]!));

    final Color txtColor = widget.textColor ??
        (widget.isPrimary
            ? Colors.white
            : (isDarkMode ? Colors.white : AppColors.textPrimary));

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null && !widget.isLoading) {
          _animationController.forward();
        }
      },
      onTapUp: (_) {
        if (widget.onPressed != null && !widget.isLoading) {
          _animationController.reverse();
        }
      },
      onTapCancel: () {
        if (widget.onPressed != null && !widget.isLoading) {
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
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                color: widget.onPressed == null
                    ? bgColor.withOpacity(0.6)
                    : bgColor,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
                boxShadow: widget.isPrimary && widget.onPressed != null
                    ? [
                        BoxShadow(
                          color: bgColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(txtColor),
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(widget.icon, color: txtColor, size: 20.sp),
                            SizedBox(width: 8.w),
                          ],
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: txtColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
