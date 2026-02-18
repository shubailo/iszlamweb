import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_stats_service.dart';
import '../../../core/theme/garden_palette.dart';
import 'package:google_fonts/google_fonts.dart';

class JourneyStatsCard extends ConsumerWidget {
  const JourneyStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyAsync = ref.watch(userJourneyProvider);

    return journeyAsync.when(
      data: (journey) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ÉN UTAM',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: GardenPalette.leafyGreen,
                  ),
                ),
                Icon(Icons.auto_graph, color: GardenPalette.leafyGreen.withAlpha(100), size: 16),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Oldal',
                  value: journey.pagesRead.toString(),
                  icon: Icons.auto_stories_outlined,
                ),
                _StatItem(
                  label: 'Khutba',
                  value: journey.khutbasListened.toString(),
                  icon: Icons.headset_outlined,
                ),
                _StatItem(
                  label: 'Nap',
                  value: journey.consecutivePrayerDays.toString(),
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                ),
                _StatItem(
                  label: 'Tasbih',
                  value: journey.tasbihCount.toString(),
                  icon: Icons.radio_button_checked_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
      loading: () => const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      )),
      error: (e, s) => const SizedBox.shrink(),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? GardenPalette.leafyGreen).withAlpha(15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor ?? GardenPalette.leafyGreen, size: 20),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: GardenPalette.nearBlack,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            color: GardenPalette.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
