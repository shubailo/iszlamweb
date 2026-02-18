class BookProgress {
  final String bookId;
  final String title;
  final String? coverUrl;
  final int currentPage;
  final int totalPages;
  final double progress; // 0.0 to 1.0
  final DateTime lastRead;

  const BookProgress({
    required this.bookId,
    required this.title,
    this.coverUrl,
    required this.currentPage,
    required this.totalPages,
    required this.progress,
    required this.lastRead,
  });
}
