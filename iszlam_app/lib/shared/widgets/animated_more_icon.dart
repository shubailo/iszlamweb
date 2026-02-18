import 'package:flutter/material.dart';

class AnimatedMoreIcon extends StatefulWidget {
  final bool isSelected;
  final Color? color;
  final double size;

  const AnimatedMoreIcon({
    required this.isSelected,
    this.color,
    this.size = 24.0,
    super.key,
  });

  @override
  State<AnimatedMoreIcon> createState() => _AnimatedMoreIconState();
}

class _AnimatedMoreIconState extends State<AnimatedMoreIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _dotAnimations = List.generate(3, (index) {
      final start = index * 0.2;
      final end = start + 0.6;
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: -4.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: -4.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0)),
        ),
      );
    });

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedMoreIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward(from: 0.0);
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.onSurface;
    final dotSize = widget.size / 5;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _dotAnimations[index],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _dotAnimations[index].value),
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
