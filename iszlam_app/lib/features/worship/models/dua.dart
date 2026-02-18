class Dua {
  final String id;
  final String categoryId;
  final String titleHu;
  final String arabicText;
  final String? vocalizedText;
  final String? translationHu;
  final String? reference;
  final int repeatCount;
  final String? audioUrl;

  Dua({
    required this.id,
    required this.categoryId,
    required this.titleHu,
    required this.arabicText,
    this.vocalizedText,
    this.translationHu,
    this.reference,
    this.repeatCount = 1,
    this.audioUrl,
  });

  factory Dua.fromSupabase(Map<String, dynamic> json) {
    return Dua(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      titleHu: json['title_hu'] as String,
      arabicText: json['arabic_text'] as String,
      vocalizedText: json['vocalized_text'] as String?,
      translationHu: json['translation_hu'] as String?,
      reference: json['reference'] as String?,
      repeatCount: json['repeat_count'] as int? ?? 1,
      audioUrl: json['audio_url'] as String?,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'category_id': categoryId,
      'title_hu': titleHu,
      'arabic_text': arabicText,
      'vocalized_text': vocalizedText,
      'translation_hu': translationHu,
      'reference': reference,
      'repeat_count': repeatCount,
      'audio_url': audioUrl,
    };
  }
}

class DuaCategory {
  final String id;
  final String nameHu;
  final String iconName;

  DuaCategory({
    required this.id,
    required this.nameHu,
    this.iconName = 'menu_book',
  });

  factory DuaCategory.fromSupabase(Map<String, dynamic> json) {
    return DuaCategory(
      id: json['id'] as String,
      nameHu: json['name_hu'] as String,
      iconName: json['icon_name'] as String? ?? 'menu_book',
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'name_hu': nameHu,
      'icon_name': iconName,
    };
  }
}
