import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/supabase_constants.dart';
import 'core/routing/app_router.dart';
import 'features/auth/auth_service.dart';
import 'features/library/services/library_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('hu', null);
  Intl.defaultLocale = 'hu';

  await Supabase.initialize(
    url: SupabaseConstants.url,
    anonKey: SupabaseConstants.anonKey,
  );

  await Hive.initFlutter();
  await LibraryService().init();

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

  runApp(
    ProviderScope(
      overrides: [
        // Inject the onboarding status into the router provider
        onboardingSeenProvider.overrideWithValue(hasSeenOnboarding),
      ],
      child: const IszlamApp(),
    ),
  );
}

class IszlamApp extends ConsumerWidget {
  const IszlamApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth stream to trigger rebuilds on auth changes if needed
    ref.watch(authStreamProvider);

    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Iszlam.com',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
