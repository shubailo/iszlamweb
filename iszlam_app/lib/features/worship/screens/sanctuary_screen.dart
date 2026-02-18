import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../services/adhan_service.dart';
import '../providers/selected_date_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/garden_palette.dart';
import '../widgets/sanctuary_hero.dart';
import '../widgets/prayer_times_card.dart';
import '../widgets/daily_inspiration_card.dart';
import '../widgets/worship_sidebar.dart';

/// "Sanctuary" — the first thing users see.
/// A serene personal worship dashboard:
/// Prayer Countdown, Quick Tools, Daily Inspiration.
class SanctuaryScreen extends ConsumerStatefulWidget {
  const SanctuaryScreen({super.key});

  @override
  ConsumerState<SanctuaryScreen> createState() => _SanctuaryScreenState();
}

class _SanctuaryScreenState extends ConsumerState<SanctuaryScreen> {
  late Timer _timer;
  Duration _countdown = Duration.zero;
  String _nextPrayerName = '';

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateCountdown() {
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

    for (final (name, time) in prayers) {
      if (time.isAfter(now)) {
        setState(() {
          _nextPrayerName = name;
          _countdown = time.difference(now);
        });
        return;
      }
    }

    // All prayers passed — show next fajr
    setState(() {
      _nextPrayerName = 'Fadzsr';
      _countdown = times.fajr.add(const Duration(days: 1)).difference(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    final coords = ref.watch(defaultLocationProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final times = ref.watch(prayerTimesForDateProvider((coords, selectedDate)));

    // Update countdown on first build
    if (_nextPrayerName.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateCountdown());
    }

    return Scaffold(
      backgroundColor: GardenPalette.white,
      drawer: WorshipSidebar(onItemTap: () => Navigator.of(context).pop()),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero Section
          SliverToBoxAdapter(
            child: SanctuaryHero(
              times: times,
              selectedDate: selectedDate,
              nextPrayerName: _nextPrayerName,
              countdown: _countdown,
            ),
          ),

          // Quick Tools removed as per request

          // Today's Prayer Times
          SliverToBoxAdapter(
            child: PrayerTimesCard(
              times: times,
              nextPrayerName: _nextPrayerName,
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.05, end: 0),
          ),

          // Daily Inspiration
          SliverToBoxAdapter(
            child: const DailyInspirationCard()
                .animate()
                .fadeIn(delay: 500.ms, duration: 600.ms)
                .slideY(begin: 0.05, end: 0),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }


}
