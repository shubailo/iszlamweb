import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../providers/quran_provider.dart';
import '../widgets/surah_tile.dart';
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
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(isDesktop ? 24 : 16, isDesktop ? 24 : 16, isDesktop ? 24 : 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(isDesktop),
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
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
                  (context, index) => SurahTile(surah: filtered[index]),
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

  Widget _buildTitle(bool isDesktop) {
    if (!isDesktop) {
      return Row(
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
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }

  Widget _buildSearchBar() {
    return TextField(
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
    );
  }
}
