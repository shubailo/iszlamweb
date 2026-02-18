import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';

class BismillahHeader extends StatelessWidget {
  final int surahIndex;
  const BismillahHeader({super.key, required this.surahIndex});

  @override
  Widget build(BuildContext context) {
    // Al-Fatiha (1) and At-Tawba (9) don't have Bismillah
    if (surahIndex == 1 || surahIndex == 9) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GardenPalette.white.withValues(alpha: 0.6),
            GardenPalette.offWhite.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GardenPalette.leafyGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Text(
          'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
          style: GoogleFonts.lateef(
            color: GardenPalette.leafyGreen,
            fontSize: 36,
            height: 1.4,
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}
