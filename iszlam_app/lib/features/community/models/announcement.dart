class Announcement {
  final String id;
  final String mosqueId;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? audioUrl; // For voice announcements

  const Announcement({
    required this.id,
    required this.mosqueId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.audioUrl,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      mosqueId: json['mosque_id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      audioUrl: json['audio_url'],
    );
  }
}
