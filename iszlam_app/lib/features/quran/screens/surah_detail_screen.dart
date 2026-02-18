import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../core/widgets/garden_error_view.dart';
import '../providers/quran_provider.dart';
import '../models/ayah.dart';
import '../widgets/bismillah_header.dart';
import '../widgets/ayah_card.dart';

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
      backgroundColor: GardenPalette.lightGrey,
      appBar: AppBar(
        backgroundColor: GardenPalette.white,
        foregroundColor: GardenPalette.nearBlack,
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
                      fontSize: 14, color: GardenPalette.leafyGreen)),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          _buildSettingsMenu(),
        ],
      ),
      body: ayahsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: GardenPalette.leafyGreen),
        ),
        error: (e, _) => GardenErrorView(message: 'Hiba: $e'),
        data: (ayahs) => _buildAyahList(ayahs),
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.tune, color: GardenPalette.nearBlack),
      color: GardenPalette.white,
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
              style: TextStyle(color: GardenPalette.nearBlack)),
        ),
        CheckedPopupMenuItem(
          value: 'transliteration',
          checked: _showTransliteration,
          child: const Text('Átírás (Latin)',
              style: TextStyle(color: GardenPalette.nearBlack)),
        ),
      ],
    );
  }

  Widget _buildAyahList(List<Ayah> ayahs) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: ayahs.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return BismillahHeader(surahIndex: widget.surahIndex);
        }
        return AyahCard(
          ayah: ayahs[index - 1],
          showTranslation: _showTranslation,
          showTransliteration: _showTransliteration,
        );
      },
    );
  }
}
