import 'package:flutter/material.dart';

/// Utility class for animations in authentication screens
class AuthAnimationUtils {
  /// Standard animation duration
  static const Duration standardDuration = Duration(milliseconds: 300);
  
  /// Quick animation duration
  static const Duration quickDuration = Duration(milliseconds: 150);
  
  /// Slow animation duration
  static const Duration slowDuration = Duration(milliseconds: 500);
  
  /// Standard animation curve
  static const Curve standardCurve = Curves.easeInOut;
  
  /// Bounce animation curve
  static const Curve bounceCurve = Curves.elasticOut;
  
  /// Fast out slow in curve
  static const Curve fastOutSlowInCurve = Curves.fastOutSlowIn;
  
  /// Fade in animation
  static Animation<double> fadeInAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }
  
  /// Slide in animation from bottom
  static Animation<Offset> slideInFromBottomAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }
  
  /// Slide in animation from top
  static Animation<Offset> slideInFromTopAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }
  
  /// Slide in animation from left
  static Animation<Offset> slideInFromLeftAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }
  
  /// Slide in animation from right
  static Animation<Offset> slideInFromRightAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }
  
  /// Scale animation
  static Animation<double> scaleAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }
  
  /// Pulse animation
  static Animation<double> pulseAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.1),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }
}
