class AzkarItem {
  final int id;
  final String arabicText; // body
  final String vocalizedText; // bodyVocalized (with tashkeel)
  final String? translation; // Nullable for now
  final String reference; // note (source)
  final int repeatCount;
  final String? audioPath; // track.id (future use)

  AzkarItem({
    required this.id,
    required this.arabicText,
    required this.vocalizedText,
    this.translation,
    required this.reference,
    required this.repeatCount,
    this.audioPath,
  });

  factory AzkarItem.fromJson(Map<String, dynamic> json) {
    // Parse track info if available
    String? audio;
    if (json['track'] != null && json['track']['id'] != null) {
      audio = json['track']['id'].toString();
    }

    return AzkarItem(
      id: json['id'] as int,
      arabicText: json['body'] as String,
      vocalizedText: json['bodyVocalized'] as String? ?? json['body'] as String,
      reference: json['note'] as String? ?? '',
      repeatCount: json['repeat'] as int? ?? 1,
      audioPath: audio,
    );
  }
}
