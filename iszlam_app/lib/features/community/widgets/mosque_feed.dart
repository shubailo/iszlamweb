import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/garden_palette.dart';
import '../../../core/widgets/garden_card.dart';
import '../../../core/widgets/garden_section_header.dart';
import '../../../core/widgets/garden_empty_state.dart';
import '../../../core/localization/hungarian_strings.dart'; // Import H

import '../providers/event_provider.dart';
import '../providers/community_provider.dart';
import '../screens/post_detail_screen.dart';
import 'community_post_card.dart';
import 'package:iszlamweb_app/features/auth/services/auth_service.dart';
import 'create_post_bar.dart';

class MosqueFeed extends ConsumerWidget {
  final String mosqueId;

  const MosqueFeed({super.key, required this.mosqueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communityPostsAsync = ref.watch(communityPostsProvider(mosqueId));
    final eventsAsync = ref.watch(mosqueEventsProvider(mosqueId));
    final isAdmin = ref.watch(isAdminProvider).value ?? false;

    return SliverList(
      delegate: SliverChildListDelegate([
        // Admin: Create Post Bar
        if (isAdmin) 
          CreatePostBar(mosqueId: mosqueId),
        
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
                              color: GardenPalette.leafyGreen,
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
                    color: GardenPalette.leafyGreen)),
          ),
          error: (e, _) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 24),

        // Community Posts (New)
        const GardenSectionHeader(
          label: H.feed,
          icon: Icons.campaign,
        ),
        communityPostsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
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
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return CommunityPostCard(
                  post: post,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(post: post),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: GardenPalette.leafyGreen),
            ),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text('Error: $e', style: const TextStyle(color: GardenPalette.errorRed)),
            ),
          ),
        ),
      ]),
    );
  }
}

