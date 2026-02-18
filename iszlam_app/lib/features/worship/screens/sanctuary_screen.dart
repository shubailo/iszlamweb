import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../../core/theme/garden_palette.dart';
import '../widgets/journey_hero.dart';
import '../widgets/journey_stats_card.dart';
import '../widgets/daily_inspiration_card.dart';
import '../widgets/worship_sidebar.dart';
import '../widgets/prayer_times_card.dart';
import '../services/user_stats_service.dart';
import '../services/adhan_service.dart';
import '../providers/selected_date_provider.dart';

class SanctuaryScreen extends ConsumerStatefulWidget {
  const SanctuaryScreen({super.key});

  @override
  ConsumerState<SanctuaryScreen> createState() => _SanctuaryScreenState();
}

class _SanctuaryScreenState extends ConsumerState<SanctuaryScreen> {
  Timer? _timer;
  String _nextPrayerName = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateNextPrayer());
  }

  void _updateNextPrayer() {
    if (!mounted) return;
    final coords = ref.read(defaultLocationProvider);
    final now = DateTime.now();
    final times = ref.read(prayerTimesForDateProvider((coords, now)));
    
    final prayers = [
      ('Fadzsr', times.fajr),
      ('Napkelte', times.sunrise),
      ('Dhuhr', times.dhuhr),
      ('Aszr', times.asr),
      ('Maghrib', times.maghrib),
      ('Isa', times.isha),
    ];

    String bestNextMatch = '';
    for (final (name, time) in prayers) {
      if (time.isAfter(now)) {
        bestNextMatch = name;
        break;
      }
    }

    if (bestNextMatch.isEmpty) bestNextMatch = 'Fadzsr';

    if (_nextPrayerName != bestNextMatch) {
      setState(() => _nextPrayerName = bestNextMatch);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    final selectedDate = ref.watch(selectedDateProvider);
    final journeyAsync = ref.watch(userJourneyProvider);
    
    final coords = ref.watch(defaultLocationProvider);
    final times = ref.watch(prayerTimesForDateProvider((coords, selectedDate)));

    if (_nextPrayerName.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateNextPrayer());
    }

    return Scaffold(
      backgroundColor: GardenPalette.offWhite,
      drawer: WorshipSidebar(onItemTap: () => Navigator.of(context).pop()),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Daily Inspiration (At the TOP now)
          SliverToBoxAdapter(
            child: const DailyInspirationCard()
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.05, end: 0),
          ),

          if (isLoggedIn) ...[
            journeyAsync.when(
              data: (journey) => SliverList(
                delegate: SliverChildListDelegate([
                  // Hero Section
                  JourneyHero(
                    journey: journey,
                    selectedDate: selectedDate,
                  ),

                  // Journey Stats Card (Overlapping like the Library cards)
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: const JourneyStatsCard()
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .slideY(begin: 0.1, end: 0),
                  ),
                ]),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, s) => SliverFillRemaining(
                child: Center(child: Text('Error: $e')),
              ),
            ),
          ] else ...[
            // GUEST VIEW: Login CTA + Prayer Timetable
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: GardenPalette.leafyGreen.withAlpha(40)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.person_outline, size: 48, color: GardenPalette.leafyGreen.withAlpha(100)),
                      const SizedBox(height: 16),
                      Text(
                        'Kövesd a spirituális utadat',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: GardenPalette.nearBlack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jelentkezz be, hogy lásd a statisztikáidat, és kövesd a fejlődésedet!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: GardenPalette.charcoal.withAlpha(150),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => GoRouter.of(context).push('/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GardenPalette.leafyGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text(
                            'BEJELENTKEZÉS',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
            ),

            SliverToBoxAdapter(
              child: PrayerTimesCard(
                times: times,
                nextPrayerName: _nextPrayerName,
              )
              .animate()
              .fadeIn(delay: 500.ms, duration: 600.ms)
              .slideY(begin: 0.1, end: 0),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}
