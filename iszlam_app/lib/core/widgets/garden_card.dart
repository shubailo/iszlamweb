import 'package:flutter/material.dart';
import '../theme/garden_palette.dart';

/// Reusable card with subtle border.
class GardenCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const GardenCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 10),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: GardenPalette.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: GardenPalette.lightGrey,
          ),
        ),
        child: child,
      ),
    );
  }
}
