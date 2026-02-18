import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/garden_palette.dart';

/// Clean empty state with icon and message.
class GardenEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const GardenEmptyState({
    super.key,
    this.icon = Icons.explore_outlined,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: GardenPalette.leafyGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 36,
                color: GardenPalette.leafyGreen.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: GardenPalette.nearBlack.withValues(alpha: 0.6),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: GardenPalette.darkGrey,
                ),
              ),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.arrow_forward,
                    size: 16, color: GardenPalette.leafyGreen),
                label: Text(
                  actionLabel!,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    color: GardenPalette.leafyGreen,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
