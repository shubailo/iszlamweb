import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/garden_palette.dart';
import '../providers/quran_provider.dart';
import '../models/surah.dart';
import '../../worship/widgets/worship_sidebar.dart';

class QuranScreen extends ConsumerStatefulWidget {
  const QuranScreen({super.key});

  @override
  ConsumerState<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends ConsumerState<QuranScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final surahsAsync = ref.watch(surahListProvider);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: GardenPalette.white,
      drawer: !isDesktop ? const WorshipSidebar() : null,
      body: CustomScrollView(
        slivers: [
          // Light header with title + search
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(isDesktop ? 24 : 16, isDesktop ? 24 : 16, isDesktop ? 24 : 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isDesktop) ...[
                      Row(
                        children: [
                          Builder(
                            builder: (context) => IconButton(
                              icon: const Icon(Icons.menu, color: GardenPalette.nearBlack),
                              onPressed: () => Scaffold.of(context).openDrawer(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Al-Quran al-Karim',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: GardenPalette.nearBlack,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Desktop: just title (sidebar handles navigation)
                      Text(
                        'Al-Quran al-Karim',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: GardenPalette.nearBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'القرآن الكريم',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: GardenPalette.leafyGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Search bar
                    TextField(
                      style: GoogleFonts.outfit(color: GardenPalette.nearBlack),
                      decoration: InputDecoration(
                        hintText: 'Szúra keresése...',
                        hintStyle: GoogleFonts.outfit(color: GardenPalette.grey),
                        prefixIcon: Icon(Icons.search, color: GardenPalette.grey),
                        filled: true,
                        fillColor: GardenPalette.offWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: GardenPalette.lightGrey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: GardenPalette.lightGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: GardenPalette.leafyGreen),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
          // Surah list
          surahsAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: GardenPalette.leafyGreen),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Text('Hiba: $e',
                    style: const TextStyle(color: GardenPalette.errorRed)),
              ),
            ),
            data: (surahs) {
              final filtered = _searchQuery.isEmpty
                  ? surahs
                  : surahs.where((s) =>
                      s.title.toLowerCase().contains(_searchQuery) ||
                      s.titleAr.contains(_searchQuery) ||
                      s.englishNameTranslation
                          .toLowerCase()
                          .contains(_searchQuery) ||
                      s.index.toString() == _searchQuery).toList();

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final surah = filtered[index];
                    return _SurahTile(surah: surah);
                  },
                  childCount: filtered.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  final Surah surah;
  const _SurahTile({required this.surah});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/quran/${surah.index}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: GardenPalette.offWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GardenPalette.lightGrey),
        ),
        child: Row(
          children: [
            // Index badge
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: GardenPalette.subtleGreenGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${surah.index}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.title,
                    style: GoogleFonts.outfit(
                      color: GardenPalette.nearBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${surah.englishNameTranslation} · ${surah.count} ája',
                    style: GoogleFonts.outfit(
                      color: GardenPalette.darkGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Arabic name + badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  surah.titleAr,
                  style: GoogleFonts.outfit(
                    color: GardenPalette.deepGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: surah.isMeccan
                        ? GardenPalette.leafyGreen.withValues(alpha: 0.1)
                        : GardenPalette.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    surah.isMeccan ? 'Mekkai' : 'Medinai',
                    style: GoogleFonts.outfit(
                      color: surah.isMeccan
                          ? GardenPalette.leafyGreen
                          : GardenPalette.amber,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
