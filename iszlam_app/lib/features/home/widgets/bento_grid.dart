import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../providers/home_mock_data.dart';
import 'bento_tile.dart';

class BentoGrid extends ConsumerWidget {
  const BentoGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(mockNewsProvider);
    final events = ref.watch(mockEventsProvider);

    // Combine for display or keep separate? 
    // Requirements: "Friss hírek" and "Friss események" sections.
    // Let's do a Section-based layout.

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          _buildSectionHeader(context, "FRISS HÍREK", Icons.newspaper),
          const SizedBox(height: 16),
          _buildNewsGrid(context, news),
          
          const SizedBox(height: 48),
          
          _buildSectionHeader(context, "FRISS ESEMÉNYEK", Icons.event),
          const SizedBox(height: 16),
          _buildEventsGrid(context, events),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: GardenPalette.gildedGold),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: GardenPalette.midnightForest.withAlpha(200),
          ),
        ),
        const Spacer(),
        Text(
          "ÖSSZES",
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: GardenPalette.emeraldTeal,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildNewsGrid(BuildContext context, List<dynamic> items) {
    // Using StaggeredGrid for that "Bento" feel
    // 2 columns on mobile, maybe 3 on tablet?
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        
        // First item is Large (full width), others vary
        final isLarge = index == 0;
        
        return StaggeredGridTile.fit(
          crossAxisCellCount: isLarge ? 2 : 1,
          child: BentoTile(item: item, isLarge: isLarge),
        );
      }).toList(),
    );
  }

  Widget _buildEventsGrid(BuildContext context, List<dynamic> items) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: items.map((item) {
        return StaggeredGridTile.fit(
          crossAxisCellCount: 1,
          child: BentoTile(item: item),
        );
      }).toList(),
    );
  }
}
