class Ayah {
  final int chapter;
  final int verse;
  final String text;
  final String? translation;
  final String? transliteration;

  Ayah({
    required this.chapter,
    required this.verse,
    required this.text,
    this.translation,
    this.transliteration,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      chapter: json['chapter'] as int,
      verse: json['verse'] as int,
      text: json['text'] as String,
    );
  }

  Ayah copyWith({String? translation, String? transliteration}) {
    return Ayah(
      chapter: chapter,
      verse: verse,
      text: text,
      translation: translation ?? this.translation,
      transliteration: transliteration ?? this.transliteration,
    );
  }
}
