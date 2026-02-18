import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/book.dart';
import '../models/reading_progress.dart';

// LibraryService is now a wrapper around Hive boxes and Supabase.
// The provider is moved to library_provider.dart to avoid duplication.

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
      
      // Clear or intelligently merge. For catalog, we usually overwrite with source of truth.
      // But we must NOT lose filePath if the book is downloaded.
      for (final item in data) {
        final onlineBook = Book.fromSupabase(item);
        final localData = _booksBox.get(onlineBook.id);
        
        if (localData != null) {
          final localBook = Book.fromJson(Map<String, dynamic>.from(localData));
          // Preserve local file path if it exists
          final mergedBook = onlineBook.copyWith(
            filePath: localBook.filePath,
            isLocal: localBook.isLocal,
            isFavorite: localBook.isFavorite,
          );
          await _booksBox.put(mergedBook.id, mergedBook.toJson());
        } else {
          await _booksBox.put(onlineBook.id, onlineBook.toJson());
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Library sync failed: $e');
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
