import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../models/ayah.dart';

class AyahCard extends StatelessWidget {
  final Ayah ayah;
  final bool showTranslation;
  final bool showTransliteration;

  const AyahCard({
    super.key,
    required this.ayah,
    required this.showTranslation,
    required this.showTransliteration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GardenPalette.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: GardenPalette.leafyGreen.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildVerseNumber(),
          const SizedBox(height: 12),
          _buildArabicText(),
          if (showTransliteration && ayah.transliteration != null) ...[
            const SizedBox(height: 10),
            _buildTransliteration(),
          ],
          if (showTranslation && ayah.translation != null) ...[
            const SizedBox(height: 10),
            _buildTranslation(),
          ],
        ],
      ),
    );
  }

  Widget _buildVerseNumber() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: GardenPalette.subtleGreenGradient,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${ayah.verse}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildArabicText() {
    return Text(
      ayah.text,
      style: GoogleFonts.lateef(
        color: GardenPalette.nearBlack,
        fontSize: 32,
        height: 1.5,
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
    );
  }

  Widget _buildTransliteration() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: GardenPalette.offWhite.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        ayah.transliteration!,
        style: TextStyle(
          color: GardenPalette.leafyGreen.withValues(alpha: 0.9),
          fontSize: 14,
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildTranslation() {
    return Text(
      ayah.translation!,
      style: TextStyle(
        color: GardenPalette.nearBlack.withValues(alpha: 0.7),
        fontSize: 14,
        height: 1.5,
      ),
    );
  }
}
