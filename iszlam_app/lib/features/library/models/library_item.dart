enum LibraryItemType {
  book,
  audio,
  video,
  article,
}

class LibraryCategory {
  final String id;
  final String label;
  final String slug;

  const LibraryCategory({
    required this.id,
    required this.label,
    required this.slug,
  });

  static const all = LibraryCategory(id: 'all', label: 'Mind', slug: 'all');
  static const general = LibraryCategory(id: 'general', label: 'Általános', slug: 'general');
}

class LibraryItem {
  final String id;
  final String title;
  final String author;
  final String description;
  final String? imageUrl;
  final LibraryItemType type;
  final String mediaUrl;
  final String? metadata;
  final DateTime? date;
  final String? categoryId; // UUID or Slug
  final String? fileUrl; // Extra field specifically for cloud file path

  const LibraryItem({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    this.imageUrl,
    required this.type,
    required this.mediaUrl,
    this.metadata,
    this.date,
    this.categoryId,
    this.fileUrl,
  });
}
