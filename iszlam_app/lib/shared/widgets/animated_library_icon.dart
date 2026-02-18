import 'package:flutter/material.dart';

class AnimatedLibraryIcon extends StatefulWidget {
  final bool isSelected;
  final Color? color;
  final double size;

  const AnimatedLibraryIcon({
    required this.isSelected,
    this.color,
    this.size = 24.0,
    super.key,
  });

  @override
  State<AnimatedLibraryIcon> createState() => _AnimatedLibraryIconState();
}

class _AnimatedLibraryIconState extends State<AnimatedLibraryIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedLibraryIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
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

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _LibraryIconPainter(
            progress: _animation.value,
            color: color,
          ),
        );
      },
    );
  }
}

class _LibraryIconPainter extends CustomPainter {
  final double progress;
  final Color color;

  _LibraryIconPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Scale from 1080x1080 to actual size
    final scale = size.width / 1080;
    canvas.scale(scale);

    // Path 1: The outer book frame and bookmark
    final path = Path();
    
    // We interpolate the key points of the path
    // Simplified representation of the Mihon library icon morph
    
    // Outer rectangle
    const double left = 270.0;
    const double top = 90.0;
    const double right = 990.0;
    const double bottom = 810.0;
    const double radius = 90.0;

    // Inner bookmark coordinates (lerp between unselected and selected)
    // Unselected (approx): Bookmark is a thin strip
    // Selected (approx): Bookmark is wider and fills more space
    
    final bLeft = lerpDouble(585.0, 675.0, progress);
    final bRight = lerpDouble(855.0, 900.0, progress);
    final bBottom = lerpDouble(585.0, 540.0, progress);
    final bMid = (bLeft + bRight) / 2;
    final bTip = lerpDouble(484.0, 472.0, progress);

    // Main body
    path.addRRect(RRect.fromLTRBR(left, top, right, bottom, const Radius.circular(radius)));
    
    // Cutout for the "book" effect
    final cutout = Path();
    cutout.moveTo(360, 180);
    cutout.lineTo(bLeft, 180);
    cutout.lineTo(bLeft, bBottom);
    cutout.lineTo(bMid, bTip);
    cutout.lineTo(bRight, bBottom);
    cutout.lineTo(bRight, 180);
    cutout.lineTo(899, 180);
    cutout.lineTo(899, 720);
    cutout.lineTo(360, 720);
    cutout.close();
    
    // Secondary "shadow" or "depth" line (angle in Mihon XML)
    final frame = Path();
    frame.moveTo(180, 270);
    frame.lineTo(180, 900);
    frame.cubicTo(180, 950, 220, 990, 270, 990); // Simplified corner
    frame.lineTo(810, 990);
    frame.lineTo(810, 900);
    frame.lineTo(180, 900);
    frame.close();

    // Use path combination for cutouts
    final finalPath = Path.combine(PathOperation.difference, path, cutout);
    canvas.drawPath(finalPath, paint);
    canvas.drawPath(frame, paint);
  }

  double lerpDouble(double start, double end, double t) {
    return start + (end - start) * t;
  }

  @override
  bool shouldRepaint(_LibraryIconPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
