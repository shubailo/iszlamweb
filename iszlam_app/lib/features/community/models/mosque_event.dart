class MosqueEvent {
  final String id;
  final String mosqueId;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime? endTime;
  final String location;
  final String? imageUrl;
  final bool requiresRegistration;

  const MosqueEvent({
    required this.id,
    required this.mosqueId,
    required this.title,
    required this.description,
    required this.startTime,
    this.endTime,
    required this.location,
    this.imageUrl,
    this.requiresRegistration = false,
  });

  factory MosqueEvent.fromJson(Map<String, dynamic> json) {
    return MosqueEvent(
      id: json['id'],
      mosqueId: json['mosque_id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['start_time']),
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      location: json['location'],
      imageUrl: json['image_url'],
      requiresRegistration: json['requires_registration'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mosque_id': mosqueId,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'location': location,
      'image_url': imageUrl,
      'requires_registration': requiresRegistration,
    };
  }
}
