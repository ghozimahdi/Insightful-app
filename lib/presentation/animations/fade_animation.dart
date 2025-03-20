import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  final double duration;
  final Widget child;
  final bool visible;

  const FadeAnimation({
    required this.child,
    super.key,
    this.duration = 0.0,
    this.visible = true,
  });

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _opacityAnimation = Tween(begin: 0 * 1.0, end: 1 * 1.0).animate(_controller);

    _processVisibility();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      _processVisibility();
    }
  }

  void _processVisibility() {
    if (widget.visible) {
      Future.delayed(Duration(milliseconds: (widget.duration * 200).round()), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Visibility(
        visible: _controller.status != AnimationStatus.dismissed,
        child: Opacity(
          opacity: _opacityAnimation.value,
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
