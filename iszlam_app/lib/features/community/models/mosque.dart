import '../../worship/models/mosque_timing.dart';

class Mosque {
  final String id;
  final String name;
  final String address;
  final String city;
  final String? imageUrl;
  final MosqueTiming? timing;

  const Mosque({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    this.imageUrl,
    this.timing,
  });

  factory Mosque.fromJson(Map<String, dynamic> json) {
    return Mosque(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      imageUrl: json['image_url'],
      timing: json['timing'] != null ? MosqueTiming.fromJson(json['timing']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'image_url': imageUrl,
      'timing': timing?.toJson(),
    };
  }
}
