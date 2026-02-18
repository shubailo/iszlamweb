class Surah {
  final int index;
  final String title;
  final String titleAr;
  final String englishNameTranslation;
  final String place;
  final String type;
  final int count;
  final int pages;

  Surah({
    required this.index,
    required this.title,
    required this.titleAr,
    required this.englishNameTranslation,
    required this.place,
    required this.type,
    required this.count,
    required this.pages,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      index: json['index'] as int,
      title: json['title'] as String,
      titleAr: json['titleAr'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String? ?? '',
      place: json['place'] as String? ?? '',
      type: json['type'] as String? ?? '',
      count: json['count'] as int,
      pages: json['pages'] as int? ?? 0,
    );
  }

  bool get isMeccan => type == 'Meccan';
}
