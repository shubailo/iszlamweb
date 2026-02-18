import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/garden_palette.dart';
import '../../../core/localization/hungarian_strings.dart';
import '../providers/library_filter_provider.dart';
import '../widgets/library_item_card.dart';
import '../widgets/library_sidebar.dart';
import '../widgets/persistent_audio_player.dart';
import '../widgets/admin_add_card.dart';
import '../../auth/services/auth_service.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredItems = ref.watch(filteredLibraryItemsProvider);
    final filter = ref.watch(libraryFilterProvider);
    final isAdmin = ref.watch(isAdminProvider).when(
      data: (value) => value,
      error: (e, s) => false,
      loading: () => false,
    );
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final crossAxisCount = isDesktop ? 4 : 2;

    // Build the grid items, including the AdminAddCard if applicable
    final gridItemCount = isAdmin ? filteredItems.length + 1 : filteredItems.length;

    final mainContent = Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _LibraryHeader(
                filter: filter,
                isDesktop: isDesktop,
              ),
            ),

            if (gridItemCount == 0)
              SliverFillRemaining(child: _EmptyState())
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16,
                  vertical: 16,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.62,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (isAdmin && index == 0) {
                        return const AdminAddCard()
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.08, end: 0);
                      }
                      
                      final itemIndex = isAdmin ? index - 1 : index;
                      final item = filteredItems[itemIndex];
                      return LibraryItemCard(item: item)
                          .animate()
                          .fadeIn(
                            duration: 400.ms,
                            delay: (index * 60).ms,
                          )
                          .slideY(begin: 0.08, end: 0);
                    },
                    childCount: gridItemCount,
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),

        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: PersistentAudioPlayer(),
        ),
      ],
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: GardenPalette.offWhite,
        body: Row(
          children: [
            const LibrarySidebar(),
            Container(width: 1, color: GardenPalette.lightGrey),
            Expanded(child: mainContent),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: GardenPalette.offWhite,
      drawer: LibrarySidebar(onItemTap: () => Navigator.of(context).pop()),
      body: mainContent,
    );
  }
}

class _LibraryHeader extends ConsumerWidget {
  final LibraryFilterState filter;
  final bool isDesktop;

  const _LibraryHeader({
    required this.filter,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: GardenPalette.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 16,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isDesktop) ...[
                IconButton(
                  icon: const Icon(Icons.menu, color: GardenPalette.nearBlack),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                const SizedBox(height: 12),
              ],

              // Search bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: GardenPalette.offWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: GardenPalette.lightGrey),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Icons.search, color: GardenPalette.grey, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (v) =>
                            ref.read(libraryFilterProvider.notifier).setSearch(v),
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: GardenPalette.nearBlack,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: H.searchLibrary,
                          hintStyle: GoogleFonts.outfit(
                            fontSize: 14,
                            color: GardenPalette.grey,
                          ),
                        ),
                      ),
                    ),
                    if (filter.searchQuery.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.close,
                            color: GardenPalette.grey, size: 18),
                        onPressed: () =>
                            ref.read(libraryFilterProvider.notifier).setSearch(''),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: GardenPalette.lightGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.search_off,
              size: 36,
              color: GardenPalette.grey,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            H.noResults,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: GardenPalette.nearBlack.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            H.noResultsSubtitle,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: GardenPalette.darkGrey,
            ),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () =>
                ref.read(libraryFilterProvider.notifier).clearAll(),
            icon: const Icon(Icons.filter_alt_off, size: 18),
            label: Text(
              H.clearFilters,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: GardenPalette.leafyGreen,
            ),
          ),
        ],
      ),
    );
  }
}
