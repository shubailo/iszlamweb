import '../../worship/models/mosque_timing.dart';


enum CommunityPrivacyType { public, restricted, private }

class Mosque {
  final String id;
  final String name;
  final String address;
  final String city;
  final String? description;
  final String? imageUrl;
  final CommunityPrivacyType privacyType;
  final MosqueTiming? timing;

  const Mosque({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    this.description,
    this.imageUrl,
    this.privacyType = CommunityPrivacyType.public,
    this.timing,
  });

  factory Mosque.fromJson(Map<String, dynamic> json) {
    return Mosque(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      description: json['description'],
      imageUrl: json['image_url'],
      privacyType: CommunityPrivacyType.values.firstWhere(
        (e) => e.name == (json['privacy_type'] ?? 'public'),
        orElse: () => CommunityPrivacyType.public,
      ),
      timing: json['timing'] != null ? MosqueTiming.fromJson(json['timing']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'description': description,
      'image_url': imageUrl,
      'privacy_type': privacyType.name,
      'timing': timing?.toJson(),
    };
  }
}
