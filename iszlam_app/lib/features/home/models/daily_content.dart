enum ContentType {
  quran,
  hadith,
  quote,
  video,
}

class DailyContent {
  final String id;
  final ContentType type;
  final String title; // "Surah Al-Imran, 3:15" or "Hadith of the Day"
  final String body; // The actual text or video URL
  final String source; // "Sahih Bukhari" or "Imam Ghazali"
  final String? imageUrl; // Optional background image

  const DailyContent({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.source,
    this.imageUrl,
  });
}
