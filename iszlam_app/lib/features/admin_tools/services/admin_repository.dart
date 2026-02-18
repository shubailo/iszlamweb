import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final adminRepositoryProvider = Provider((ref) => AdminRepository());

final adminBooksProvider = FutureProvider((ref) async {
  return ref.watch(adminRepositoryProvider).getBooks();
});

final adminCategoriesProvider = FutureProvider((ref) async {
  return ref.watch(adminRepositoryProvider).getCategories();
});

final adminKhutbasProvider = FutureProvider((ref) async {
  return ref.watch(adminRepositoryProvider).getKhutbas();
});

class AdminRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // --- Upload Files ---

  Future<String> uploadFile({
    required String bucket,
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    await _supabase.storage.from(bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType, upsert: true),
        );
    return _supabase.storage.from(bucket).getPublicUrl(path);
  }

  // --- Database Inserts ---

  Future<void> createBook({
    required String title,
    required String author,
    required String? description,
    String? categoryId,
    required String fileUrl,
    required String? coverUrl,
    required Map<String, dynamic> metadata,
  }) async {
    await _supabase.from('books').insert({
      'title': title,
      'author': author,
      'description': description,
      'category_id': categoryId,
      'file_url': fileUrl,
      'cover_url': coverUrl,
      'metadata': metadata,
      'created_by': _supabase.auth.currentUser?.id,
    });
  }

  Future<void> createKhutba({
    required String title,
    required String speaker,
    required DateTime date,
    String? categoryId,
    required String audioUrl,
    required String? description,
  }) async {
    await _supabase.from('khutbas').insert({
      'title': title,
      'speaker': speaker,
      'date': date.toIso8601String().split('T').first, // Format YYYY-MM-DD
      'category_id': categoryId,
      'audio_url': audioUrl,
      'description': description,
      'created_by': _supabase.auth.currentUser?.id,
    });
  }

  Future<void> createCategory({
    required String labelHu,
    required String slug,
    required String type, // 'book', 'audio', 'both'
  }) async {
    await _supabase.from('library_categories').insert({
      'label_hu': labelHu,
      'slug': slug,
      'type': type,
    });
  }
  
  // --- Fetch Data ---
  
  Future<List<Map<String, dynamic>>> getBooks() async {
    final data = await _supabase.from('books').select().order('title');
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getKhutbas() async {
    final data = await _supabase.from('khutbas').select().order('date', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final data = await _supabase.from('library_categories').select().order('label_hu');
    return List<Map<String, dynamic>>.from(data);
  }

  // --- Updates ---

  Future<void> updateBook(String id, Map<String, dynamic> data) async {
    await _supabase.from('books').update(data).eq('id', id);
  }

  Future<void> updateKhutba(String id, Map<String, dynamic> data) async {
    await _supabase.from('khutbas').update(data).eq('id', id);
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    await _supabase.from('library_categories').update(data).eq('id', id);
  }

  // --- Deletion ---

  Future<void> deleteBook(String id) async {
    await _supabase.from('books').delete().eq('id', id);
  }

  Future<void> deleteKhutba(String id) async {
    await _supabase.from('khutbas').delete().eq('id', id);
  }

  Future<void> deleteCategory(String id) async {
    await _supabase.from('library_categories').delete().eq('id', id);
  }

  // --- Users ---

  Future<List<Map<String, dynamic>>> getUsers() async {
    final data = await _supabase.from('profiles').select().order('full_name');
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> toggleAdminStatus(String userId, bool isAdmin) async {
    await _supabase.from('profiles').update({'is_admin': isAdmin}).eq('id', userId);
  }
}

final usersProvider = FutureProvider((ref) async {
  return ref.watch(adminRepositoryProvider).getUsers();
});
