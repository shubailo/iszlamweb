import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/surah.dart';
import '../models/ayah.dart';

class QuranDataService {
  List<Surah>? _cachedSurahs;
  Map<int, List<Ayah>>? _cachedAyahs;
  Map<int, List<Map<String, dynamic>>>? _cachedTranslations;
  Map<int, List<Map<String, dynamic>>>? _cachedTransliterations;

  Future<List<Surah>> loadSurahs() async {
    if (_cachedSurahs != null) return _cachedSurahs!;

    final String jsonString =
        await rootBundle.loadString('assets/data/quran/surah.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _cachedSurahs = jsonList.map((j) => Surah.fromJson(j)).toList();
    return _cachedSurahs!;
  }

  Future<List<Ayah>> loadAyahsForSurah(int surahIndex) async {
    if (_cachedAyahs != null && _cachedAyahs!.containsKey(surahIndex)) {
      return _cachedAyahs![surahIndex]!;
    }

    // Load full Quran if not cached
    if (_cachedAyahs == null) {
      _cachedAyahs = {};
      final String jsonString =
          await rootBundle.loadString('assets/data/quran/quran.json');
      final Map<String, dynamic> quranMap = json.decode(jsonString);

      for (var entry in quranMap.entries) {
        final int chapterNum = int.parse(entry.key);
        final List<dynamic> verses = entry.value;
        _cachedAyahs![chapterNum] =
            verses.map((v) => Ayah.fromJson(v)).toList();
      }
    }

    // Enrich with translations if available
    await _loadTranslations();
    await _loadTransliterations();

    if (_cachedAyahs!.containsKey(surahIndex)) {
      final ayahs = _cachedAyahs![surahIndex]!;

      // Merge translations
      final translations = _cachedTranslations?[surahIndex];
      final transliterations = _cachedTransliterations?[surahIndex];

      if (translations != null || transliterations != null) {
        for (int i = 0; i < ayahs.length; i++) {
          String? trans;
          String? translit;

          if (translations != null && i < translations.length) {
            trans = translations[i]['text'] as String?;
          }
          if (transliterations != null && i < transliterations.length) {
            translit = transliterations[i]['text'] as String?;
          }

          if (trans != null || translit != null) {
            ayahs[i] = ayahs[i].copyWith(
              translation: trans,
              transliteration: translit,
            );
          }
        }
      }

      return ayahs;
    }

    return [];
  }

  Future<void> _loadTranslations() async {
    if (_cachedTranslations != null) return;
    try {
      _cachedTranslations = {};
      final String jsonString =
          await rootBundle.loadString('assets/data/quran/en.json');
      final Map<String, dynamic> map = json.decode(jsonString);
      for (var entry in map.entries) {
        final int chapterNum = int.parse(entry.key);
        _cachedTranslations![chapterNum] =
            List<Map<String, dynamic>>.from(entry.value);
      }
    } catch (_) {
      _cachedTranslations = {};
    }
  }

  Future<void> _loadTransliterations() async {
    if (_cachedTransliterations != null) return;
    try {
      _cachedTransliterations = {};
      final String jsonString =
          await rootBundle.loadString('assets/data/quran/transliteration.json');
      final Map<String, dynamic> map = json.decode(jsonString);
      for (var entry in map.entries) {
        final int chapterNum = int.parse(entry.key);
        _cachedTransliterations![chapterNum] =
            List<Map<String, dynamic>>.from(entry.value);
      }
    } catch (_) {
      _cachedTransliterations = {};
    }
  }
}
