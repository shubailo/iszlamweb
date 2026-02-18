import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/garden_palette.dart';

/// Reusable section header with uppercase label.
class GardenSectionHeader extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;

  const GardenSectionHeader({
    super.key,
    required this.label,
    this.icon,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: GardenPalette.leafyGreen),
            const SizedBox(width: 8),
          ],
          Text(
            label.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: GardenPalette.nearBlack.withValues(alpha: 0.5),
            ),
          ),
          if (actionText != null) ...[
            const Spacer(),
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionText!,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: GardenPalette.leafyGreen,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
