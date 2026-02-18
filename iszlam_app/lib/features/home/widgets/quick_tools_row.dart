
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../core/localization/hungarian_strings.dart'; // Import H

class QuickToolsRow extends StatelessWidget {
  const QuickToolsRow({super.key});

  @override
  Widget build(BuildContext context) {
    // Adapted from Mi-raj 'ToolsRow'
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20), // Glassmorphism
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ToolItem(
            icon: Icons.explore,
            label: H.qibla,
            onTap: () => context.go('/qibla'),
          ),
          _ToolItem(
            icon: Icons.fingerprint, // Tasbih icon alternative
            label: H.tasbih,
            onTap: () => context.go('/tasbih'),
          ),
          _ToolItem(
            icon: Icons.history, // Missed prayers
            label: H.missedPrayer,
            onTap: () => context.go('/missed'),
          ),
        ],
      ),
    );
  }
}

class _ToolItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ToolItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: GardenPalette.nearBlack.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: GardenPalette.nearBlack, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: GardenPalette.nearBlack,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
