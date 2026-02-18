class MosqueGroup {
  final String id;
  final String mosqueId;
  final String name;
  final String description;
  final String leaderName;
  final String meetingTime;
  final String? imageUrl;
  final bool isPrivate;

  const MosqueGroup({
    required this.id,
    required this.mosqueId,
    required this.name,
    required this.description,
    required this.leaderName,
    required this.meetingTime,
    this.imageUrl,
    this.isPrivate = false,
  });

  factory MosqueGroup.fromJson(Map<String, dynamic> json) {
    return MosqueGroup(
      id: json['id'],
      mosqueId: json['mosque_id'],
      name: json['name'],
      description: json['description'],
      leaderName: json['leader_name'],
      meetingTime: json['meeting_time'],
      imageUrl: json['image_url'],
      isPrivate: json['is_private'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mosque_id': mosqueId,
      'name': name,
      'description': description,
      'leader_name': leaderName,
      'meeting_time': meetingTime,
      'image_url': imageUrl,
      'is_private': isPrivate,
    };
  }
}
