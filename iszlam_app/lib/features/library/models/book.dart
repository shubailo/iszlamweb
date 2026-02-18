
class Book {
  final String id;
  final String title;
  final String author;
  final String filePath;
  final String? coverPath;
  final String? downloadUrl;
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
      filePath: '', // Remote books don't have a local path initially
      coverPath: json['cover_url'],
      downloadUrl: json['file_url'],
      format: 'pdf', // Assume PDF for now, or check metadata
      addedAt: DateTime.parse(json['created_at']),
      isLocal: false,
      categoryId: json['category_id'],
    );
  }
}
