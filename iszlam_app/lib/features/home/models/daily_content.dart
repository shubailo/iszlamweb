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

  factory DailyContent.fromJson(Map<String, dynamic> json) {
    return DailyContent(
      id: json['id'],
      type: ContentType.values.byName(json['type']),
      title: json['title'],
      body: json['body'],
      source: json['source'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'body': body,
      'source': source,
      'image_url': imageUrl,
    };
  }
}
