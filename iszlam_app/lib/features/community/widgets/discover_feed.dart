import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/garden_palette.dart';
import '../../../core/widgets/garden_card.dart';
import '../../../core/widgets/garden_section_header.dart';
import '../../../core/widgets/garden_search_bar.dart';
import '../../../core/localization/hungarian_strings.dart'; // Import H

import '../providers/mosque_provider.dart';

class DiscoverFeed extends ConsumerWidget {
  const DiscoverFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mosquesAsync = ref.watch(mosqueListProvider);

    // Static placeholder data for events & resources to simplify
    // In a real app these would likely come from other providers
    final events = [
      (H.communityIftar, 'Pénteken este', Icons.restaurant,
          GardenPalette.gildedGold),
      (H.weeklyQuranCircle, 'Szerdánként', Icons.menu_book,
          GardenPalette.royalNavy),
      (H.youthProgram, 'Szombat 10:00', Icons.sports_soccer,
          GardenPalette.vibrantEmerald),
    ];

    return SliverList(
      delegate: SliverChildListDelegate([
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GardenSearchBar(hintText: H.searchCommunityHint),
        ),
        const SizedBox(height: 24),

        // Nearby mosques
        const GardenSectionHeader(
          label: H.nearbyMosques,
          icon: Icons.mosque,
        ),
        mosquesAsync.when(
          data: (mosques) => SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mosques.length,
              itemBuilder: (context, index) {
                final m = mosques[index];
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 10),
                  child: GardenCard(
                    margin: EdgeInsets.zero,
                    onTap: () => ref
                        .read(selectedMosqueIdProvider.notifier)
                        .update(m.id),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: GardenPalette.emeraldTeal
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.mosque,
                                  color: GardenPalette.emeraldTeal, size: 16),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                m.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: GardenPalette.nearBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          '${m.address}, ${m.city}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: GardenPalette.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          loading: () => const SizedBox(
            height: 110,
            child: Center(
                child: CircularProgressIndicator(
                    color: GardenPalette.emeraldTeal)),
          ),
          error: (e, _) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 24),

        // Upcoming events
        const GardenSectionHeader(
          label: H.trendingEvents,
          icon: Icons.event_available,
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final (title, sub, icon, color) = events[index];
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 10),
                child: GardenCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 16, color: color),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: GardenPalette.nearBlack)),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(sub,
                          style: GoogleFonts.outfit(
                              fontSize: 11, color: GardenPalette.darkGrey)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // Resources
        const GardenSectionHeader(
          label: H.recommendedReading,
          icon: Icons.auto_stories,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              GardenCard(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            GardenPalette.gildedGold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_stories,
                          color: GardenPalette.gildedGold, size: 18),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(H.ramadanGuide,
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: GardenPalette.nearBlack)),
                          Text(H.publication,
                              style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: GardenPalette.ivory
                                      .withValues(alpha: 0.35))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GardenCard(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            GardenPalette.emeraldTeal.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.menu_book,
                          color: GardenPalette.emeraldTeal, size: 18),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(H.powerOfPrayer,
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: GardenPalette.nearBlack)),
                          Text(H.publication,
                              style: GoogleFonts.outfit(
                                  fontSize: 11, color: GardenPalette.darkGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ]),
    );
  }
}
