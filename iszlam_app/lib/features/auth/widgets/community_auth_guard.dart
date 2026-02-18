import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart'; // For authStreamProvider

class CommunityAuthGuard extends ConsumerWidget {
  final Widget child;

  const CommunityAuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch aut stream to rebuild on auth changes
    final authState = ref.watch(authStreamProvider);
    
    return authState.when(
      data: (session) {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          return child;
        } else {
          return _buildGuestView(context);
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => _buildGuestView(context), // Fallback to guest view on error
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 80, color: Theme.of(context).primaryColor.withAlpha(100)),
              const SizedBox(height: 24),
              Text(
                'Join the Community',
                style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Connect with others, share your journey, and participate in events.',
                style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.push('/login'),
                icon: const Icon(Icons.login),
                label: const Text('Log In'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.push('/register'),
                child: const Text('Create an Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
