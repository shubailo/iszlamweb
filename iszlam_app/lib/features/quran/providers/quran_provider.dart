import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/surah.dart';
import '../models/ayah.dart';
import '../services/quran_data_service.dart';

final quranDataServiceProvider = Provider<QuranDataService>((ref) {
  return QuranDataService();
});

final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final service = ref.watch(quranDataServiceProvider);
  return service.loadSurahs();
});

final surahAyahsProvider =
    FutureProvider.family<List<Ayah>, int>((ref, surahIndex) async {
  final service = ref.watch(quranDataServiceProvider);
  return service.loadAyahsForSurah(surahIndex);
});
