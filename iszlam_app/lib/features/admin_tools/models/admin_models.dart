// Type-safe models for admin entity types.
//
// Replaces untyped `Map<String, dynamic>` patterns with compile-time safe
// models while keeping Supabase JSON serialization painless.

class AdminBook {
  final String id;
  final String title;
  final String author;
  final String? description;
  final String? categoryId;
  final String? fileUrl;
  final String? epubUrl;
  final String? coverUrl;
  final dynamic metadata;

  const AdminBook({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    this.categoryId,
    this.fileUrl,
    this.epubUrl,
    this.coverUrl,
    this.metadata,
  });

  factory AdminBook.fromJson(Map<String, dynamic> json) => AdminBook(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        author: json['author'] as String? ?? '',
        description: json['description'] as String?,
        categoryId: json['category_id'] as String?,
        fileUrl: json['file_url'] as String?,
        epubUrl: json['epub_url'] as String?,
        coverUrl: json['cover_url'] as String?,
        metadata: json['metadata'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'description': description,
        'category_id': categoryId,
        'file_url': fileUrl,
        'epub_url': epubUrl,
        'cover_url': coverUrl,
        'metadata': metadata,
      };
}

class AdminKhutba {
  final String id;
  final String title;
  final String speaker;
  final String? date;
  final String? categoryId;
  final String? audioUrl;
  final String? description;

  const AdminKhutba({
    required this.id,
    required this.title,
    required this.speaker,
    this.date,
    this.categoryId,
    this.audioUrl,
    this.description,
  });

  factory AdminKhutba.fromJson(Map<String, dynamic> json) => AdminKhutba(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        speaker: json['speaker'] as String? ?? '',
        date: json['date'] as String?,
        categoryId: json['category_id'] as String?,
        audioUrl: json['audio_url'] as String?,
        description: json['description'] as String?,
      );
}

class AdminCategory {
  final String id;
  final String labelHu;
  final String? slug;
  final String? type;

  const AdminCategory({
    required this.id,
    required this.labelHu,
    this.slug,
    this.type,
  });

  factory AdminCategory.fromJson(Map<String, dynamic> json) =>
      AdminCategory(
        id: json['id'] as String,
        labelHu: json['label_hu'] as String? ?? '',
        slug: json['slug'] as String?,
        type: json['type'] as String?,
      );
}

class AdminUser {
  final String id;
  final String? fullName;
  final String? email;
  final bool isAdmin;

  const AdminUser({
    required this.id,
    this.fullName,
    this.email,
    this.isAdmin = false,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
        id: json['id'] as String,
        fullName: json['full_name'] as String?,
        email: json['email'] as String?,
        isAdmin: json['is_admin'] == true,
      );

  String get displayName => fullName ?? 'Névtelen felhasználó';

  String get initial =>
      fullName != null && fullName!.isNotEmpty ? fullName![0].toUpperCase() : '?';
}

class AdminInspiration {
  final String id;
  final String title;
  final String body;
  final String? source;
  final String? type;
  final bool isActive;

  const AdminInspiration({
    required this.id,
    required this.title,
    required this.body,
    this.source,
    this.type,
    this.isActive = false,
  });

  factory AdminInspiration.fromJson(Map<String, dynamic> json) =>
      AdminInspiration(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        source: json['source'] as String?,
        type: json['type'] as String?,
        isActive: json['is_active'] == true,
      );
}

class AdminMosque {
  final String id;
  final String name;
  final String address;
  final String city;
  final String? description;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;

  const AdminMosque({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    this.description,
    this.imageUrl,
    this.latitude,
    this.longitude,
  });

  factory AdminMosque.fromJson(Map<String, dynamic> json) => AdminMosque(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        address: json['address'] as String? ?? '',
        city: json['city'] as String? ?? '',
        description: json['description'] as String?,
        imageUrl: json['image_url'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'city': city,
        'description': description,
        'image_url': imageUrl,
        'latitude': latitude,
        'longitude': longitude,
      };
}
