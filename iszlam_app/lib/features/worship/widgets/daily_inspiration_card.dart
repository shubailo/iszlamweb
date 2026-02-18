import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/garden_palette.dart';
import '../../../core/localization/hungarian_strings.dart';

class DailyInspirationCard extends StatelessWidget {
  const DailyInspirationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              GardenPalette.deepGreen,
              GardenPalette.leafyGreen,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
               color: GardenPalette.deepGreen.withAlpha(40),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_stories,
                    size: 16, color: GardenPalette.gildedGold),
                const SizedBox(width: 8),
                Text(
                  H.dailyGuidance,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: GardenPalette.gildedGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '„Bizony, a nehézséggel könnyebbség jár."',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '— Korán 94:6 (As-Sarh)',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: Colors.white.withAlpha(180),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
