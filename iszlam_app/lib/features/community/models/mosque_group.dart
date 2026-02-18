import 'mosque.dart';

class MosqueGroup {
  final String id;
  final String mosqueId;
  final String name;
  final String description;
  final String leaderName;
  final String meetingTime;
  final String? imageUrl;
  final CommunityPrivacyType privacyType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MosqueGroup({
    required this.id,
    required this.mosqueId,
    required this.name,
    required this.description,
    required this.leaderName,
    required this.meetingTime,
    this.imageUrl,
    this.privacyType = CommunityPrivacyType.public,
    required this.createdAt,
    required this.updatedAt,
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
      privacyType: CommunityPrivacyType.values.firstWhere(
        (e) => e.name == (json['privacy_type'] ?? 'public'),
        orElse: () => CommunityPrivacyType.public,
      ),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
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
      'privacy_type': privacyType.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
