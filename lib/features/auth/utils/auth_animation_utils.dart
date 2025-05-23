import 'package:flutter/material.dart';

/// Utility class for auth-specific animations
class AuthAnimationUtils {
  /// Creates a widget that fades in
  static Widget fadeIn({
    required Widget child,
    required AnimationController controller,
    Curve curve = Curves.easeIn,
    double begin = 0.0,
    double end = 1.0,
  }) {
    final Animation<double> fadeAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }

  /// Creates a widget that fades and slides in
  static Widget fadeSlideIn({
    required Widget child,
    required AnimationController controller,
    Curve curve = Curves.easeOut,
    Offset slideBegin = const Offset(0, 30),
    Offset slideEnd = Offset.zero,
    double fadeBegin = 0.0,
    double fadeEnd = 1.0,
  }) {
    final Animation<double> fadeAnimation = Tween<double>(
      begin: fadeBegin,
      end: fadeEnd,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );

    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: slideBegin,
      end: slideEnd,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }

  /// Creates a widget that scales
  static Widget scale({
    required Widget child,
    required AnimationController controller,
    Curve curve = Curves.easeOut,
    double begin = 0.8,
    double end = 1.0,
  }) {
    final Animation<double> scaleAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );

    return ScaleTransition(
      scale: scaleAnimation,
      child: child,
    );
  }

  /// Creates a widget that slides in
  static Widget slideIn({
    required Widget child,
    required AnimationController controller,
    Curve curve = Curves.easeOut,
    Offset begin = const Offset(0, 30),
    Offset end = Offset.zero,
  }) {
    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );

    return SlideTransition(
      position: slideAnimation,
      child: child,
    );
  }
}
