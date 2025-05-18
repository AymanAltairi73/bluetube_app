import 'package:flutter/material.dart';

/// Utility class for animations
class AnimationUtils {
  /// Duration for quick animations (buttons, small UI elements)
  static const Duration quickDuration = Duration(milliseconds: 150);
  
  /// Duration for medium animations (expandable sections, cards)
  static const Duration mediumDuration = Duration(milliseconds: 300);
  
  /// Duration for slow animations (page transitions, complex animations)
  static const Duration slowDuration = Duration(milliseconds: 500);
  
  /// Standard curve for most animations
  static const Curve standardCurve = Curves.easeInOut;
  
  /// Bounce curve for playful animations
  static const Curve bounceCurve = Curves.elasticOut;
  
  /// Decelerate curve for natural feeling animations
  static const Curve decelerateCurve = Curves.decelerate;
  
  /// Creates a scale animation controller
  static AnimationController createScaleController(
    TickerProvider vsync, {
    Duration? duration,
  }) {
    return AnimationController(
      vsync: vsync,
      duration: duration ?? quickDuration,
    );
  }
  
  /// Creates a fade animation controller
  static AnimationController createFadeController(
    TickerProvider vsync, {
    Duration? duration,
  }) {
    return AnimationController(
      vsync: vsync,
      duration: duration ?? quickDuration,
    );
  }
  
  /// Creates a slide animation controller
  static AnimationController createSlideController(
    TickerProvider vsync, {
    Duration? duration,
  }) {
    return AnimationController(
      vsync: vsync,
      duration: duration ?? mediumDuration,
    );
  }
  
  /// Creates a scale animation
  static Animation<double> createScaleAnimation(
    AnimationController controller, {
    double begin = 1.0,
    double end = 1.05,
    Curve? curve,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve ?? standardCurve,
      ),
    );
  }
  
  /// Creates a fade animation
  static Animation<double> createFadeAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
    Curve? curve,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve ?? standardCurve,
      ),
    );
  }
  
  /// Creates a slide animation
  static Animation<Offset> createSlideAnimation(
    AnimationController controller, {
    Offset begin = const Offset(0.0, 0.2),
    Offset end = Offset.zero,
    Curve? curve,
  }) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve ?? standardCurve,
      ),
    );
  }
}
