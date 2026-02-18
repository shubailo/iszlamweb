import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/garden_palette.dart';
import '../../community/providers/mosque_provider.dart';

/// "Discover" screen — Kotatsu's "Browse" equivalent.
/// The marketplace for finding new communities, events, and resources.
class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mosquesAsync = ref.watch(mosqueListProvider);

    return Scaffold(
      backgroundColor: GardenPalette.offWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: _buildHeader(context),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: _buildSearchBar(context)
                .animate()
                .fadeIn(delay: 100.ms, duration: 500.ms),
          ),

          // Featured Section (Carousel)
          SliverToBoxAdapter(
            child: _buildFeaturedSection(context)
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.05, end: 0),
          ),

          // Mosques Section
          SliverToBoxAdapter(
            child: _buildSectionHeader('Mecsetek a közeledben', Icons.mosque)
                .animate()
                .fadeIn(delay: 300.ms, duration: 500.ms),
          ),
          SliverToBoxAdapter(
            child: mosquesAsync.when(
              data: (mosques) => _buildHorizontalCards(
                context,
                mosques
                    .map((m) => _DiscoverItem(
                          title: m.name,
                          subtitle: '${m.address}, ${m.city}',
                          icon: Icons.mosque,
                          color: GardenPalette.emeraldTeal,
                        ))
                    .toList(),
              ),
              loading: () => const SizedBox(
                height: 140,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, s) => SizedBox(
                height: 140,
                child: Center(child: Text('Hiba: $e')),
              ),
            ),
          ),

          // Events Section
          SliverToBoxAdapter(
            child:
                _buildSectionHeader('Közelgő események', Icons.event_available)
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 500.ms),
          ),
          SliverToBoxAdapter(
            child: _buildHorizontalCards(
              context,
              [
                _DiscoverItem(
                  title: 'Közösségi Iftár',
                  subtitle: 'Pénteken este · Fő terem',
                  icon: Icons.restaurant,
                  color: GardenPalette.gildedGold,
                ),
                _DiscoverItem(
                  title: 'Heti Korán Kör',
                  subtitle: 'Szerdánként maghrib után',
                  icon: Icons.menu_book,
                  color: GardenPalette.royalNavy,
                ),
                _DiscoverItem(
                  title: 'Ifjúsági Program',
                  subtitle: 'Szombaton 10:00',
                  icon: Icons.sports_soccer,
                  color: GardenPalette.vibrantEmerald,
                ),
              ],
            ),
          ),

          // Resources Section
          SliverToBoxAdapter(
            child:
                _buildSectionHeader('Ajánlott olvasmányok', Icons.auto_stories)
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 500.ms),
          ),
          SliverToBoxAdapter(
            child: _buildResourcesGrid(context),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [GardenPalette.midnightForest, Color(0xFF063A2E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Felfedezés',
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: GardenPalette.ivory,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Találj új közösségeket és eseményeket',
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: GardenPalette.ivory.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Keresés mecsetek, események között...',
            hintStyle: GoogleFonts.outfit(
              color: GardenPalette.midnightForest.withAlpha(100),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: GardenPalette.emeraldTeal.withAlpha(150),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [GardenPalette.emeraldTeal, GardenPalette.vibrantEmerald],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: GardenPalette.emeraldTeal.withAlpha(60),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative pattern
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.star_border,
                size: 200,
                color: Colors.white.withAlpha(15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'KIEMELT',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ramadán Felkészülés 2026',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Csatlakozz a közösségi programokhoz',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.white.withAlpha(200),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: GardenPalette.emeraldTeal),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: GardenPalette.midnightForest.withAlpha(150),
            ),
          ),
          const Spacer(),
          Text(
            'Összes',
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: GardenPalette.emeraldTeal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCards(
      BuildContext context, List<_DiscoverItem> items) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: GardenPalette.midnightForest.withAlpha(15),
                ),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: item.color.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, color: item.color, size: 20),
                    ),
                    const Spacer(),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: GardenPalette.midnightForest,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: GardenPalette.midnightForest.withAlpha(120),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: (index * 100).ms, duration: 400.ms)
              .slideX(begin: 0.1, end: 0);
        },
      ),
    );
  }

  Widget _buildResourcesGrid(BuildContext context) {
    final resources = [
      _DiscoverItem(
          title: 'Az imádság ereje',
          subtitle: 'Kiadvány',
          icon: Icons.menu_book,
          color: GardenPalette.emeraldTeal),
      _DiscoverItem(
          title: 'Ramadán útmutató',
          subtitle: 'Kiadvány',
          icon: Icons.auto_stories,
          color: GardenPalette.gildedGold),
      _DiscoverItem(
          title: 'Pénteki beszéd',
          subtitle: 'Hanganyag',
          icon: Icons.mic,
          color: GardenPalette.royalNavy),
      _DiscoverItem(
          title: 'Iszlám a mindennapokban',
          subtitle: 'Kiadvány',
          icon: Icons.article,
          color: GardenPalette.vibrantEmerald),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          childAspectRatio: 1.3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final r = resources[index];
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: GardenPalette.midnightForest.withAlpha(15),
              ),
            ),
            color: Colors.white,
            child: InkWell(
              onTap: () => context.go('/library'),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: r.color.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(r.icon, color: r.color, size: 18),
                    ),
                    const Spacer(),
                    Text(
                      r.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: GardenPalette.midnightForest,
                      ),
                    ),
                    Text(
                      r.subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: GardenPalette.midnightForest.withAlpha(100),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: (index * 80).ms, duration: 400.ms)
              .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
        },
      ),
    );
  }
}

class _DiscoverItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _DiscoverItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
