import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_progress.dart';

// --- Reading Progress Provider ---
// Returns the user's current reading activity, most recent first.
// Mock data for now, but will connect to Supabase 'reading_progress' table.

final recentReadingProvider = FutureProvider<List<BookProgress>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 300));
  
  return [
    BookProgress(
      bookId: '101',
      title: 'Gardens of the Righteous',
      coverUrl: null,
      currentPage: 42,
      totalPages: 350,
      progress: 0.12,
      lastRead: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    BookProgress(
      bookId: '102',
      title: 'Purification of the Heart',
      coverUrl: null,
      currentPage: 15,
      totalPages: 120,
      progress: 0.125,
      lastRead: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
});
