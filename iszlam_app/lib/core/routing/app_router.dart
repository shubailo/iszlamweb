import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../layout/responsive_navigation_shell.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/community/screens/my_community_screen.dart';
import '../../features/worship/screens/prayer_home_screen.dart';
import '../../features/worship/screens/worship_screen_wrapper.dart';
import '../../features/library/screens/library_screen.dart';
import '../../features/more/screens/more_screen.dart';
import '../../features/islamic_tools/screens/qibla_screen.dart';
import '../../features/islamic_tools/screens/tasbih_screen.dart';
import '../../features/islamic_tools/screens/asmaul_husna_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/quran/screens/quran_screen.dart';
import '../../features/quran/screens/surah_detail_screen.dart';
import '../../features/admin_tools/screens/admin_users_screen.dart';
import '../../features/admin_tools/screens/admin_inspiration_screen.dart';
import '../../features/auth/services/auth_service.dart';

// Provider to determine if user has seen onboarding
// This should be overridden in main.dart with the value from SharedPreferences
final onboardingSeenProvider = Provider<bool>((ref) => false);

final goRouterProvider = Provider<GoRouter>((ref) {
  final hasSeenOnboarding = ref.read(onboardingSeenProvider);

  return GoRouter(
    initialLocation: hasSeenOnboarding ? '/community' : '/onboarding',

    redirect: (context, state) {
      final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
      final isAuthRoute = state.uri.path == '/login' || state.uri.path == '/register';

      if (isLoggedIn && isAuthRoute) return '/';

      // Admin Guard
      if (state.uri.path.startsWith('/admin')) {
        if (!isLoggedIn) return '/login';
        
        // We can't easily wait for a profile fetch in a synchronous redirect
        // However, we can check the current provider state if it's already loaded
        final isAdminAsync = ref.read(isAdminProvider);
        return isAdminAsync.when(
          data: (isAdmin) => isAdmin ? null : '/',
          loading: () => null, // Let it load, dashboard will handle loading state or we can use a splash
          error: (e, s) => '/',
        );
      }

      return null;
    },
    
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ResponsiveNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 1: Sanctuary (Worship Dashboard)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const WorshipScreenWrapper(),
              ),
            ],
          ),
          // Tab 2: Community (merged Community + Discover)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/community',
                builder: (context, state) => const MyCommunityScreen(),
              ),
            ],
          ),
          // Tab 3: Library (Books/Audio)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          // Tab 4: More (Utilities + Settings)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (context, state) => const MoreScreen(),
              ),
            ],
          ),
        ],
      ),
      
      // Standalone routes
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/qibla', builder: (context, state) => const QiblaScreen()),
      GoRoute(path: '/worship', builder: (context, state) => const PrayerHomeScreen()),
      GoRoute(path: '/quran', builder: (context, state) => const QuranScreen()),
      GoRoute(
        path: '/quran/:surahIndex',
        builder: (context, state) {
          final idx = int.parse(state.pathParameters['surahIndex']!);
          return SurahDetailScreen(surahIndex: idx);
        },
      ),
      GoRoute(path: '/tasbih', builder: (context, state) => const TasbihScreen()),
      GoRoute(path: '/asmaul-husna', builder: (context, state) => const AsmaulHusnaScreen()),

      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      
      GoRoute(
        path: '/admin',
        redirect: (context, state) => '/admin/users',
        routes: [
          GoRoute(
            path: 'users',
            builder: (context, state) => const AdminUsersScreen(),
          ),
          GoRoute(
            path: 'inspiration',
            builder: (context, state) => const AdminInspirationScreen(),
          ),
        ],
      ),
    ],
  );
});
