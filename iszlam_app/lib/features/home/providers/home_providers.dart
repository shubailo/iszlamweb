import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_content.dart';

// --- Mood Provider ---
// Manages the user's current selected mood/feeling
class MoodNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  
  void setMood(String? mood) => state = mood;
}

final moodProvider = NotifierProvider<MoodNotifier, String?>(MoodNotifier.new);

// --- Daily Content Provider ---
// Fetches the main inspiration content for the home page.
// Currently returns mock data, but can be connected to Supabase later.

final dailyContentProvider = FutureProvider<DailyContent>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));

  // Mock Data: Rotation logic could be added here later
  return const DailyContent(
    id: '1',
    type: ContentType.quran,
    title: 'Surah Al-Inshirah (94:5-6)',
    body: 'For indeed, with hardship [will be] ease. Indeed, with hardship [will be] ease.',
    source: 'The Holy Quran',
    imageUrl: null, // Placeholder to avoid asset errors
  );
});
