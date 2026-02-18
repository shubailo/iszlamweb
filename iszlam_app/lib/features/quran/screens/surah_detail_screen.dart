import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../providers/quran_provider.dart';
import '../models/ayah.dart';

class SurahDetailScreen extends ConsumerStatefulWidget {
  final int surahIndex;
  const SurahDetailScreen({super.key, required this.surahIndex});

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  bool _showTranslation = true;
  bool _showTransliteration = false;

  @override
  Widget build(BuildContext context) {
    final surahsAsync = ref.watch(surahListProvider);
    final ayahsAsync = ref.watch(surahAyahsProvider(widget.surahIndex));

    final surah = surahsAsync.whenData((surahs) =>
        surahs.firstWhere((s) => s.index == widget.surahIndex));

    return Scaffold(
      backgroundColor: GardenPalette.obsidian,
      appBar: AppBar(
        backgroundColor: GardenPalette.midnightForest,
        foregroundColor: GardenPalette.ivory,
        title: surah.when(
          loading: () => const Text('...'),
          error: (_, _) => const Text('Hiba'),
          data: (s) => Column(
            children: [
              Text(s.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              Text(s.titleAr,
                  style: const TextStyle(
                      fontSize: 14, color: GardenPalette.gildedGold)),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune, color: GardenPalette.ivory),
            color: GardenPalette.midnightForest,
            onSelected: (value) {
              setState(() {
                if (value == 'translation') {
                  _showTranslation = !_showTranslation;
                } else if (value == 'transliteration') {
                  _showTransliteration = !_showTransliteration;
                }
              });
            },
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: 'translation',
                checked: _showTranslation,
                child: const Text('English fordítás',
                    style: TextStyle(color: GardenPalette.ivory)),
              ),
              CheckedPopupMenuItem(
                value: 'transliteration',
                checked: _showTransliteration,
                child: const Text('Átírás (Latin)',
                    style: TextStyle(color: GardenPalette.ivory)),
              ),
            ],
          ),
        ],
      ),
      body: ayahsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: GardenPalette.emeraldTeal),
        ),
        error: (e, _) => Center(
          child: Text('Hiba: $e',
              style: const TextStyle(color: GardenPalette.warningRed)),
        ),
        data: (ayahs) => _buildAyahList(ayahs),
      ),
    );
  }

  Widget _buildAyahList(List<Ayah> ayahs) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: ayahs.length + 1, // +1 for Bismillah header
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildBismillah();
        }
        return _buildAyahCard(ayahs[index - 1]);
      },
    );
  }

  Widget _buildBismillah() {
    if (widget.surahIndex == 1 || widget.surahIndex == 9) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GardenPalette.midnightForest.withValues(alpha: 0.6),
            GardenPalette.velvetNavy.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GardenPalette.gildedGold.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Text(
          'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
          style: GoogleFonts.lateef(
            color: GardenPalette.gildedGold,
            fontSize: 36,
            height: 1.4,
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  Widget _buildAyahCard(Ayah ayah) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GardenPalette.midnightForest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: GardenPalette.emeraldTeal.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Verse number badge
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: GardenPalette.vibrantEmeraldGradient,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${ayah.verse}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          // Arabic text
          Text(
            ayah.text,
            style: GoogleFonts.lateef(
              color: GardenPalette.ivory,
              fontSize: 32,
              height: 1.5,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          // Transliteration
          if (_showTransliteration && ayah.transliteration != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: GardenPalette.velvetNavy.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                ayah.transliteration!,
                style: TextStyle(
                  color: GardenPalette.emeraldTeal.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),
          ],
          // Translation
          if (_showTranslation && ayah.translation != null) ...[
            const SizedBox(height: 10),
            Text(
              ayah.translation!,
              style: TextStyle(
                color: GardenPalette.ivory.withValues(alpha: 0.7),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
