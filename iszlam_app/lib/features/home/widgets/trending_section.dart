import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/garden_palette.dart';
import '../../../core/localization/hungarian_strings.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                H.trendingNow.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: GardenPalette.white.withAlpha(150),
                ),
              ),
              TextButton(
                onPressed: () => context.go('/library'),
                child: Text(
                  H.viewAll,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: GardenPalette.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTrendingCard(
            context,
            'Az imádság ereje',
            'Hogyan találjuk meg a belső békét a napi rohanásban?',
            null,
          ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.05, end: 0),
          _buildTrendingCard(
            context,
            'Ramadán felkészülés',
            'Gyakorlati tanácsok a szent hónap előtt.',
            null,
          ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.05, end: 0),
        ],
      ),
    );
  }

  Widget _buildTrendingCard(
    BuildContext context,
    String title,
    String subtitle,
    String? imageUrl,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: GardenPalette.white.withAlpha(20), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => context.go('/library'),
          child: ListTile(
            contentPadding: const EdgeInsets.all(20),
            leading: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: GardenPalette.white.withAlpha(10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.article_outlined,
                  color: GardenPalette.white, size: 20),
            ),
            title: Text(
              title,
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: GardenPalette.white,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  color: GardenPalette.white.withAlpha(150),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
