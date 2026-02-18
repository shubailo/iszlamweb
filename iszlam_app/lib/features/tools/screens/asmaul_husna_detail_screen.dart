import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../shared/models/asmaul_husna.dart';

class AsmaulHusnaDetailScreen extends StatelessWidget {
  final AsmaulHusna name;

  const AsmaulHusnaDetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GardenPalette.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: GardenPalette.nearBlack),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                   Text(
                    '#${name.number}',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: GardenPalette.leafyGreen,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name.arabic,
                    style: GoogleFonts.amiri(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: GardenPalette.leafyGreen,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name.transliteration,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: GardenPalette.nearBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name.meaningHu,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      color: GardenPalette.darkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Info Sections
            _buildSection(
              title: 'Mit jelent?',
              content: name.descriptionHu ?? 'Hamarosan...',
              icon: Icons.lightbulb_outline,
            ),
            
            const SizedBox(height: 24),
            
            _buildSection(
              title: 'Eredet',
              content: name.originHu ?? 'Hamarosan...',
              icon: Icons.history,
            ),
            
            const SizedBox(height: 24),
            
            _buildSection(
              title: 'Említések a Koránban',
              content: name.mentionsHu ?? 'Hamarosan...',
              icon: Icons.menu_book,
            ),
            
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: GardenPalette.leafyGreen, size: 20),
            const SizedBox(width: 8),
            Text(
              title.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: GardenPalette.leafyGreen,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: GardenPalette.offWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GardenPalette.lightGrey),
          ),
          child: Text(
            content,
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: GardenPalette.nearBlack,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
