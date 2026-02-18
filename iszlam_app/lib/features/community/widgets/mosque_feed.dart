import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/garden_palette.dart';
import '../../../core/widgets/garden_card.dart';
import '../../../core/widgets/garden_section_header.dart';
import '../../../core/widgets/garden_empty_state.dart';
import '../../../core/localization/hungarian_strings.dart'; // Import H

import '../providers/event_provider.dart';

class MosqueFeed extends ConsumerWidget {
  final String mosqueId;

  const MosqueFeed({super.key, required this.mosqueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsProvider(mosqueId));
    final eventsAsync = ref.watch(mosqueEventsProvider(mosqueId));

    return SliverList(
      delegate: SliverChildListDelegate([
        // Events for this mosque
        const GardenSectionHeader(
          label: H.events,
          icon: Icons.event,
        ),
        eventsAsync.when(
          data: (events) {
            if (events.isEmpty) return const SizedBox.shrink();
            return SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final e = events[index];
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 10),
                    child: GardenCard(
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: GardenPalette.nearBlack)),
                          const Spacer(),
                          Text(
                            '${e.startTime.month}/${e.startTime.day} · ${e.startTime.hour}:${e.startTime.minute.toString().padLeft(2, '0')}',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: GardenPalette.gildedGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const SizedBox(
            height: 90,
            child: Center(
                child: CircularProgressIndicator(
                    color: GardenPalette.emeraldTeal)),
          ),
          error: (e, _) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 24),

        // Announcements
        const GardenSectionHeader(
          label: H.feed,
          icon: Icons.campaign,
        ),
        announcementsAsync.when(
          data: (announcements) {
             if (announcements.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: GardenEmptyState(
                  icon: Icons.campaign_outlined,
                  title: H.noAnnouncements,
                ),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final a = announcements[index];
                return GardenCard(
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
                                size: 14, color: GardenPalette.emeraldTeal),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              a.title,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: GardenPalette.nearBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        a.content,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          height: 1.5,
                          color: GardenPalette.darkGrey,
                        ),
                      ),
                      if (a.audioUrl != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: GardenPalette.emeraldTeal
                                .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.play_circle_fill,
                                  color: GardenPalette.emeraldTeal, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                H.listenAudio,
                                style: GoogleFonts.outfit(
                                  color: GardenPalette.emeraldTeal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        a.createdAt.toString().split(' ')[0],
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: GardenPalette.darkGrey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const SizedBox(
            height: 200,
            child: Center(
                child: CircularProgressIndicator(
                    color: GardenPalette.emeraldTeal)),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Text('Hiba: $e',
                    style:
                        const TextStyle(color: GardenPalette.warningRed))),
          ),
        ),
      ]),
    );
  }
}

