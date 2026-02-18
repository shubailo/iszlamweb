import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

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

  // Mihon path data from anim_library_enter.xml
  static const String pathUnselected = 
      "M 634.454 90.84 C 543.069 90.84 451.685 90.84 360.3 90.84 C 310.84 90.84 270.38 131.3 270.38 180.76 C 270.38 360.61 270.38 540.46 270.38 720.31 C 270.38 769.76 310.84 810.23 360.3 810.23 C 540.147 810.23 719.993 810.23 899.84 810.23 C 949.3 810.23 989.77 769.76 989.77 720.31 C 989.77 540.46 989.77 360.61 989.77 180.76 C 989.77 131.3 949.3 90.84 899.84 90.84 C 811.378 90.84 722.916 90.84 634.454 90.84 M 899.84 720.31 C 834.876 720.31 769.913 720.31 704.949 720.31 C 590.066 720.31 475.183 720.31 360.3 720.31 C 360.3 540.46 360.3 360.61 360.3 180.76 C 435.237 180.76 510.173 180.76 585.11 180.76 L 585.11 180.76 C 585.11 315.647 585.11 450.533 585.11 585.42 C 630.073 551.7 675.037 517.98 720 484.26 C 764.96 517.98 809.92 551.7 854.88 585.42 C 854.88 450.533 854.88 315.647 854.88 180.76 C 869.867 180.76 884.853 180.76 899.84 180.76 C 899.84 360.61 899.84 540.46 899.84 720.31";

  static const String pathSelected = 
      "M 900 90 C 720 90 540 90 360 90 C 310.5 90 270 130.5 270 180 C 270 360 270 540 270 720 C 270 769.5 310.5 810 360 810 C 540 810 720 810 900 810 C 949.5 810 990 769.5 990 720 C 990 540 990 360 990 180 C 990 130.5 949.5 90 900 90 C 900 90 900 90 900 90 M 900 540 C 862.5 517.5 825 495 787.5 472.5 C 750 495 712.5 517.5 675 540 C 675 540 675 540 675 540 C 675 471.351 675 402.701 675 334.052 L 675 180 C 675 180 675 180 675 180 C 713.708 180 752.416 180 791.124 180 C 827.416 180 863.708 180 900 180 C 900 233.194 900 286.387 900 339.581 C 900 406.387 900 473.194 900 540 C 900 540 900 540 900 540";

  static const String pathAngle = 
      "M 180.45 270.69 C 180.45 270.69 90.53 270.69 90.53 270.69 C 90.53 270.69 90.53 900.15 90.53 900.15 C 90.53 949.61 131 990.08 180.45 990.08 C 180.45 990.08 809.92 990.08 809.92 990.08 C 809.92 990.08 809.92 900.15 809.92 900.15 C 809.92 900.15 180.45 900.15 180.45 900.15 C 180.45 270.69 180.45 270.69 180.45 270.69";

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final scale = size.width / 1080;
    canvas.scale(scale);

    // Use path_drawing to parse strings
    final unselectedPath = parseSvgPathData(pathUnselected);
    final selectedPath = parseSvgPathData(pathSelected);
    final anglePath = parseSvgPathData(pathAngle);

    
    if (progress < 1.0) {
      canvas.drawPath(unselectedPath, paint..color = color.withAlpha(((1.0 - progress) * 255).toInt()));
    }
    if (progress > 0.0) {
      canvas.drawPath(selectedPath, paint..color = color.withAlpha((progress * 255).toInt()));
    }
    
    // Draw the angle/depth part
    canvas.drawPath(anglePath, paint);
  }

  @override
  bool shouldRepaint(_LibraryIconPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
