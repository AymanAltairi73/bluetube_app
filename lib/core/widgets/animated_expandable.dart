import 'package:flutter/material.dart';
import '../animations/animation_utils.dart';

/// An animated expandable widget that smoothly expands and collapses
class AnimatedExpandable extends StatefulWidget {
  final Widget header;
  final Widget content;
  final bool isExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final Duration duration;
  final Curve curve;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const AnimatedExpandable({
    super.key,
    required this.header,
    required this.content,
    this.isExpanded = false,
    this.onExpansionChanged,
    this.duration = AnimationUtils.mediumDuration,
    this.curve = AnimationUtils.standardCurve,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  State<AnimatedExpandable> createState() => _AnimatedExpandableState();
}

class _AnimatedExpandableState extends State<AnimatedExpandable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconTurns;
  late Animation<double> _opacity;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _heightFactor = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );
    _iconTurns = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.5,
          1.0,
          curve: widget.curve,
        ),
      ),
    );

    _isExpanded = widget.isExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedExpandable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      _handleExpansionChange();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleExpansionChange() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!(_isExpanded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          InkWell(
            onTap: _handleExpansionChange,
            child: Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: Row(
                children: [
                  Expanded(child: widget.header),
                  RotationTransition(
                    turns: _iconTurns,
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ),
          // Content
          ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _heightFactor.value,
                  child: FadeTransition(
                    opacity: _opacity,
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: widget.padding ?? EdgeInsets.zero,
                child: widget.content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
