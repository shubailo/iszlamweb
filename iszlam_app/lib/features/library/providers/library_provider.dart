
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/library_service.dart';
import '../models/book.dart';
import '../models/reading_progress.dart';

final libraryServiceProvider = Provider<LibraryService>((ref) {
  return LibraryService();
});

final libraryInitProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(libraryServiceProvider);
  await service.init();
});

final libraryBooksProvider = FutureProvider<List<Book>>((ref) async {
  await ref.watch(libraryInitProvider.future);
  final service = ref.watch(libraryServiceProvider);
  return service.getAllBooks();
});

final libraryProgressProvider = FutureProvider.family<ReadingProgress?, String>((ref, bookId) async {
  await ref.watch(libraryInitProvider.future);
  final service = ref.watch(libraryServiceProvider);
  return service.getProgress(bookId);
});
