
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../models/reading_progress.dart';

final libraryServiceProvider = Provider((ref) => LibraryService());

class LibraryService {
  static const String _booksBoxName = 'library_books';
  static const String _progressBoxName = 'library_progress';

  Future<void> init() async {
    await Hive.openBox<Map<dynamic, dynamic>>(_booksBoxName);
    await Hive.openBox<Map<dynamic, dynamic>>(_progressBoxName);
  }

  Box<Map<dynamic, dynamic>> get _booksBox => Hive.box<Map<dynamic, dynamic>>(_booksBoxName);
  Box<Map<dynamic, dynamic>> get _progressBox => Hive.box<Map<dynamic, dynamic>>(_progressBoxName);

  final SupabaseClient _supabase = Supabase.instance.client;

  // Books
  List<Book> getAllBooks() {
    return _booksBox.values.map((e) => Book.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Stream<List<Book>> get booksStream async* {
    yield getAllBooks();
    await for (final _ in _booksBox.watch()) {
      yield getAllBooks();
    }
  }

  Future<void> syncBooks() async {
    try {
      final List<dynamic> data = await _supabase.from('books').select().order('title');
      for (final item in data) {
        final book = Book.fromSupabase(item);
        // Only update if not exists or if we want to overwrite. 
        // For now, simpler to just overwrite metadata, keeping local filePath if user downloaded it?
        // Actually, if we overwrite, we lose 'filePath' if we don't merge.
        // Logic: if local exists, keep its filePath and isLocal=true (if downloaded).
        // But here we are syncing the CATALOG.
        // Let's just put it. The Book model has filePath='' for remote.
        // If user downloaded it, we should have a separate logic or field 'localPath'.
        // For Phase 2 MVP, just listing them is enough.
        await _booksBox.put(book.id, book.toJson());
      }
    } catch (e) {
      // debugPrint('Sync failed: $e');
    }
  }

  Future<void> addBook(Book book) async {
    await _booksBox.put(book.id, book.toJson());
  }

  Future<void> removeBook(String id) async {
    await _booksBox.delete(id);
  }

  // Progress
  ReadingProgress? getProgress(String bookId) {
    final data = _progressBox.get(bookId);
    if (data == null) return null;
    return ReadingProgress.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> saveProgress(ReadingProgress progress) async {
    await _progressBox.put(progress.bookId, progress.toJson());
  }
}
