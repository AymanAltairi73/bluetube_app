import 'package:flutter/material.dart';
import '../animations/animation_utils.dart';

/// An animated button that scales and changes opacity when pressed
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;
  final Curve curve;
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.95,
    this.duration = AnimationUtils.quickDuration,
    this.curve = AnimationUtils.standardCurve,
    this.color,
    this.borderRadius,
    this.padding,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.onTap != null) {
          _controller.forward();
        }
      },
      onTapUp: (_) {
        if (widget.onTap != null) {
          _controller.reverse();
        }
      },
      onTapCancel: () {
        if (widget.onTap != null) {
          _controller.reverse();
        }
      },
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: widget.borderRadius,
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
