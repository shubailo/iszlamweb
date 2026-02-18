import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/daily_content.dart';

// --- Mood Provider ---
// Manages the user's current selected mood/feeling
class MoodNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  
  void setMood(String? mood) => state = mood;
}

final moodProvider = NotifierProvider<MoodNotifier, String?>(MoodNotifier.new);

final dailyContentProvider = FutureProvider<DailyContent>((ref) async {
  final supabase = Supabase.instance.client;
  
  try {
    final response = await supabase
        .from('daily_inspiration')
        .select()
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      return const DailyContent(
        id: 'fallback',
        type: ContentType.quran,
        title: 'Surah Al-Inshirah (94:5-6)',
        body: 'For indeed, with hardship [will be] ease. Indeed, with hardship [will be] ease.',
        source: 'The Holy Quran',
      );
    }

    return DailyContent.fromJson(response);
  } catch (e) {
    rethrow;
  }
});
