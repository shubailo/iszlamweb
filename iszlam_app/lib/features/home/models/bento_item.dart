class BentoItem {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String category; // 'news', 'event', 'wisdom'
  final DateTime? date;

  const BentoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.imageUrl,
    this.date,
  });
}
