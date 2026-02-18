
class ReadingProgress {
  final String bookId;
  final int currentPage; // For PDF
  final String? cfi; // For EPUB (locator)
  final double percentage;
  final DateTime lastReadAt;

  ReadingProgress({
    required this.bookId,
    required this.currentPage,
    this.cfi,
    required this.percentage,
    required this.lastReadAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'currentPage': currentPage,
      'cfi': cfi,
      'percentage': percentage,
      'lastReadAt': lastReadAt.toIso8601String(),
    };
  }

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      bookId: json['bookId'],
      currentPage: json['currentPage'],
      cfi: json['cfi'],
      percentage: json['percentage'],
      lastReadAt: DateTime.parse(json['lastReadAt']),
    );
  }
}
