class AsmaulHusna {
  final String id;
  final int number;
  final String arabic;
  final String transliteration;
  final String meaningHu;
  final String? descriptionHu;
  final String? originHu;
  final String? mentionsHu;

  AsmaulHusna({
    required this.id,
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.meaningHu,
    this.descriptionHu,
    this.originHu,
    this.mentionsHu,
  });

  factory AsmaulHusna.fromSupabase(Map<String, dynamic> json) {
    return AsmaulHusna(
      id: json['id'] as String,
      number: json['number'] as int,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      meaningHu: json['meaning_hu'] as String,
      descriptionHu: json['description_hu'] as String?,
      originHu: json['origin_hu'] as String?,
      mentionsHu: json['mentions_hu'] as String?,
    );
  }

  // Helper to convert from old JSON format if necessary
  factory AsmaulHusna.fromJson(Map<String, dynamic> json) {
    return AsmaulHusna(
      id: '', // Not in JSON
      number: json['number'] as int,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      meaningHu: json['meaning'] as String,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'number': number,
      'arabic': arabic,
      'transliteration': transliteration,
      'meaning_hu': meaningHu,
      'description_hu': descriptionHu,
      'origin_hu': originHu,
      'mentions_hu': mentionsHu,
    };
  }
}
