import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../models/surah.dart';

class SurahTile extends StatelessWidget {
  final Surah surah;
  const SurahTile({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/quran/${surah.index}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: GardenPalette.offWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GardenPalette.lightGrey),
        ),
        child: Row(
          children: [
            _buildIndexBadge(),
            const SizedBox(width: 14),
            _buildNames(),
            _buildArabicSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildIndexBadge() {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: GardenPalette.subtleGreenGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '${surah.index}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildNames() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            surah.title,
            style: GoogleFonts.outfit(
              color: GardenPalette.nearBlack,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${surah.englishNameTranslation} · ${surah.count} ája',
            style: GoogleFonts.outfit(
              color: GardenPalette.darkGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArabicSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          surah.titleAr,
          style: GoogleFonts.outfit(
            color: GardenPalette.deepGreen,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: surah.isMeccan
                ? GardenPalette.leafyGreen.withValues(alpha: 0.1)
                : GardenPalette.amber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            surah.isMeccan ? 'Mekkai' : 'Medinai',
            style: GoogleFonts.outfit(
              color: surah.isMeccan
                  ? GardenPalette.leafyGreen
                  : GardenPalette.amber,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
