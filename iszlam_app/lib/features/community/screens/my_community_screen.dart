import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/garden_palette.dart';
import '../providers/mosque_provider.dart';
import '../widgets/community_sidebar.dart';
import '../widgets/discover_feed.dart';
import '../widgets/mosque_feed.dart';
import '../../auth/services/auth_service.dart';
import 'create_post_screen.dart';

/// Reddit-style Community screen.
/// Mobile: hamburger → drawer sidebar.
/// Desktop: persistent left sidebar.
class MyCommunityScreen extends ConsumerWidget {
  const MyCommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final selectedId = ref.watch(selectedMosqueIdProvider);
    final mosquesAsync = ref.watch(mosqueListProvider);

    // Resolve display title
    final title = mosquesAsync.when(
      data: (mosques) {
        if (selectedId == null) return 'Közösségem';
        final m = mosques.where((m) => m.id == selectedId);
        return m.isNotEmpty ? m.first.name : 'Közösségem';
      },
      loading: () => 'Közösségem',
      error: (_, _) => 'Közösségem',
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: GardenPalette.white,
        body: Row(
          children: [
            const CommunitySidebar(),
            Container(width: 1, color: GardenPalette.lightGrey),
            Expanded(child: _FeedArea(title: title)),
          ],
        ),
      );
    }

    final isAdminAsync = ref.watch(isAdminProvider);

    return Scaffold(
      backgroundColor: GardenPalette.white,
      drawer: CommunitySidebar(
        onItemTap: () => Navigator.of(context).pop(),
      ),
      floatingActionButton: isAdminAsync.when(
        data: (admin) => admin && selectedId != null
            ? FloatingActionButton(
                backgroundColor: GardenPalette.leafyGreen,
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreatePostScreen(mosqueId: selectedId),
                  ),
                ),
              )
            : null,
        loading: () => null,
        error: (_, _) => null,
      ),
      body: _FeedArea(title: title, showMenuButton: true),
    );
  }
}

/// The main content area: header + scrollable feed.
class _FeedArea extends ConsumerWidget {
  final String title;
  final bool showMenuButton;

  const _FeedArea({required this.title, this.showMenuButton = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedMosqueIdProvider);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // App bar removed as per request
        if (showMenuButton)
          SliverToBoxAdapter(
            child: Container(
              color: GardenPalette.white,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: GardenPalette.nearBlack),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: GardenPalette.nearBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // Content depends on selection
        if (selectedId == null)
          // "All" view → Discover-style mixed feed
          const DiscoverFeed()
        else
          // Specific mosque → announcements
          MosqueFeed(mosqueId: selectedId),

        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}
