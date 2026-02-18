import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/garden_palette.dart';

class ArchedPortal extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final bool showBorder;

  const ArchedPortal({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: showBorder
          ? BoxDecoration(
              border: Border.all(
                color: GardenPalette.leafyGreen.withAlpha(100),
                width: 1,
              ),
            )
          : null,
      child: ClipPath(
        clipper: ArchClipper(),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: GardenPalette.greenGradient,
                ),
              ),
            ),
            // Content with Reveal
            child.animate().fadeIn(duration: 400.ms, curve: Curves.easeOut).moveY(
                  begin: 10,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOutCubic,
                ),
          ],
        ),
      ),
    );
  }
}

class ArchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = w / 2;

    path.moveTo(0, h);
    path.lineTo(0, r);
    // Simple Perfect Arch
    path.arcToPoint(
      Offset(w, r),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(w, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class GildedFlourish extends StatelessWidget {
  final Widget child;
  final bool isActive;

  const GildedFlourish({
    super.key,
    required this.child,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) return child;

    return child
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 3.seconds,
          color: GardenPalette.paleGreen.withAlpha(150),
          angle: 45,
        ); // Subtle presence
  }
}
