import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../services/adhan_service.dart';
import '../providers/selected_date_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/garden_palette.dart';
import '../widgets/prayer_times_card.dart';
import '../widgets/worship_sidebar.dart';

class PrayerTimesScreen extends ConsumerStatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  ConsumerState<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends ConsumerState<PrayerTimesScreen> {
  late Timer _timer;
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
        });
        return;
      }
    }

    setState(() {
      _nextPrayerName = 'Fadzsr';
    });
  }

  @override
  Widget build(BuildContext context) {
    final coords = ref.watch(defaultLocationProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final times = ref.watch(prayerTimesForDateProvider((coords, selectedDate)));

    if (_nextPrayerName.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateCountdown());
    }

    return Scaffold(
      backgroundColor: GardenPalette.white,
      appBar: AppBar(
        title: const Text('Imaidők'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: GardenPalette.nearBlack,
      ),
      drawer: WorshipSidebar(onItemTap: () => Navigator.of(context).pop()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrayerTimesCard(
              times: times,
              nextPrayerName: _nextPrayerName,
            )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.05, end: 0),
            
            const SizedBox(height: 20),
            // Could add a monthly calendar here if expanded in Phase 2
          ],
        ),
      ),
    );
  }
}
