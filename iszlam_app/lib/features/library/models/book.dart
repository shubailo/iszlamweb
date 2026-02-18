
class Book {
  final String id;
  final String title;
  final String author;
  final String filePath;
  final String? coverPath;
  final String? downloadUrl;
  final String? epubUrl;
  final String format;
  final DateTime addedAt;
  final bool isLocal;
  final bool isFavorite;

  final String? categoryId;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.filePath,
    this.coverPath,
    this.downloadUrl,
    this.epubUrl,
    required this.format,
    required this.addedAt,
    this.isLocal = true,
    this.isFavorite = false,
    this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'filePath': filePath,
      'coverPath': coverPath,
      'downloadUrl': downloadUrl,
      'epubUrl': epubUrl,
      'format': format,
      'addedAt': addedAt.toIso8601String(),
      'isLocal': isLocal,
      'isFavorite': isFavorite,
      'categoryId': categoryId,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      filePath: json['filePath'],
      coverPath: json['coverPath'],
      downloadUrl: json['downloadUrl'],
      epubUrl: json['epubUrl'],
      format: json['format'],
      addedAt: DateTime.parse(json['addedAt']),
      isLocal: json['isLocal'] ?? true,
      isFavorite: json['isFavorite'] ?? false,
      categoryId: json['categoryId'],
    );
  }

  factory Book.fromSupabase(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'] ?? 'Unknown',
      filePath: '',
      coverPath: json['cover_url'],
      downloadUrl: json['file_url'],
      epubUrl: json['epub_url'],
      format: (json['metadata'] as Map<String, dynamic>?)?['format'] ?? 'pdf',
      addedAt: DateTime.parse(json['created_at']),
      isLocal: false,
      categoryId: json['category_id'],
    );
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? filePath,
    String? coverPath,
    String? downloadUrl,
    String? epubUrl,
    String? format,
    DateTime? addedAt,
    bool? isLocal,
    bool? isFavorite,
    String? categoryId,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      filePath: filePath ?? this.filePath,
      coverPath: coverPath ?? this.coverPath,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      epubUrl: epubUrl ?? this.epubUrl,
      format: format ?? this.format,
      addedAt: addedAt ?? this.addedAt,
      isLocal: isLocal ?? this.isLocal,
      isFavorite: isFavorite ?? this.isFavorite,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
