import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final authServiceProvider = Provider((ref) => AuthService());

// Provider for Auth Stream to trigger rebuilds on login/logout
final authStreamProvider = StreamProvider<AuthState>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});

final isAdminProvider = FutureProvider<bool>((ref) async {
  ref.watch(authStreamProvider); // Rebuild on auth change
  final auth = ref.watch(authServiceProvider);
  return await auth.isAdmin;
});

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<void> signUp(String email, String password) async {
    await _supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<bool> get isAdmin async {
    final user = currentUser;
    if (user == null) return false;
    try {
      final data = await _supabase
          .from('profiles')
          .select('is_admin')
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) {
        debugPrint('Admin Check: No profile found for user ${user.id} (${user.email})');
        return false;
      }

      final isAdminResult = data['is_admin'] == true;
      debugPrint('Admin Check for ${user.email}: $isAdminResult');
      return isAdminResult;
    } catch (e) {
      debugPrint('Admin Check Error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
