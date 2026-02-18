import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adhan/adhan.dart';
import '../../../core/theme/garden_palette.dart';
import '../models/prayer_time.dart';
import '../services/adhan_service.dart';
import '../../community/providers/mosque_provider.dart';
import '../services/jamat_calculator.dart';
import '../models/mosque_timing.dart';
import '../providers/calendar_provider.dart';

import '../widgets/prayer_list_item.dart';
import '../widgets/spiritual_toolbar.dart';
import '../widgets/week_calendar_strip.dart';

class PrayerHomeScreen extends ConsumerWidget {
  const PrayerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(defaultLocationProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final prayerTimes = ref.watch(prayerTimesForDateProvider((location, selectedDate)));
    final selectedMosqueId = ref.watch(selectedMosqueIdProvider);
    final mosqueListAsync = ref.watch(mosqueListProvider);

    MosqueTiming? mosqueTiming;
    if (selectedMosqueId != null && mosqueListAsync.hasValue) {
      final mosques = mosqueListAsync.value!;
      final selectedMosque = mosques.firstWhere(
        (m) => m.id == selectedMosqueId,
        orElse: () => mosques.first,
      );
      mosqueTiming = selectedMosque.timing;
    }

    Map<Prayer, DateTime>? jamatTimes;
    if (mosqueTiming != null) {
      jamatTimes = {
        Prayer.fajr: JamatCalculator.calculateJamatTime(prayerTimes.fajr, mosqueTiming.fajr),
        Prayer.dhuhr: JamatCalculator.calculateJamatTime(prayerTimes.dhuhr, mosqueTiming.dhuhr),
        Prayer.asr: JamatCalculator.calculateJamatTime(prayerTimes.asr, mosqueTiming.asr),
        Prayer.maghrib: JamatCalculator.calculateJamatTime(prayerTimes.maghrib, mosqueTiming.maghrib),
        Prayer.isha: JamatCalculator.calculateJamatTime(prayerTimes.isha, mosqueTiming.isha),
      };
    }

    final isToday = _isSameDay(selectedDate, DateTime.now());

    return Scaffold(
      backgroundColor: GardenPalette.midnightForest,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Compact Header with countdown
          SliverToBoxAdapter(
            child: _buildCompactHeader(context, prayerTimes, isToday),
          ),

          // Week Calendar Strip
          const SliverToBoxAdapter(
            child: WeekCalendarStrip(),
          ),

          // Divider
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(
                color: GardenPalette.emeraldTeal.withValues(alpha: 0.15),
                height: 1,
              ),
            ),
          ),

          // Prayer List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildPrayerList(context, prayerTimes, jamatTimes, isToday),
            ),
          ),

          // Jummah Card
          if (mosqueTiming != null && mosqueTiming.jummahTimes.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: _buildJummahCard(context, mosqueTiming.jummahTimes),
              ),
            ),

          // Spiritual Toolbar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'ESZKÖZÖK',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: GardenPalette.paleGold,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SpiritualToolbar(),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildCompactHeader(BuildContext context, DailyPrayerTimes times, bool isToday) {
    if (!isToday) {
      // Non-today: just show selected date info
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
        decoration: const BoxDecoration(
          gradient: GardenPalette.deepDepthGradient,
        ),
        child: Center(
          child: Text(
            'Imarendek',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    // Today: show countdown to next prayer
    final now = DateTime.now();
    String nextName = 'Fajr';
    DateTime nextTime = times.fajr;

    if (now.isAfter(times.fajr) && now.isBefore(times.dhuhr)) {
      nextName = 'Dhuhr';
      nextTime = times.dhuhr;
    } else if (now.isAfter(times.dhuhr) && now.isBefore(times.asr)) {
      nextName = 'Asr';
      nextTime = times.asr;
    } else if (now.isAfter(times.asr) && now.isBefore(times.maghrib)) {
      nextName = 'Maghrib';
      nextTime = times.maghrib;
    } else if (now.isAfter(times.maghrib) && now.isBefore(times.isha)) {
      nextName = 'Isha';
      nextTime = times.isha;
    } else if (now.isAfter(times.isha)) {
      nextName = 'Fajr';
      nextTime = times.fajr.add(const Duration(days: 1));
    }

    final diff = nextTime.difference(now);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    final countdown = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
      decoration: const BoxDecoration(
        gradient: GardenPalette.deepDepthGradient,
      ),
      child: Column(
        children: [
          Text(
            '$nextName in',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: GardenPalette.paleGold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            countdown,
            style: GoogleFonts.playfairDisplay(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.0,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerList(BuildContext context, DailyPrayerTimes times, Map<Prayer, DateTime>? jamatTimes, bool isToday) {
    Prayer? nextPrayer;
    if (isToday) {
      final now = DateTime.now();
      if (now.isBefore(times.fajr)) {
        nextPrayer = Prayer.fajr;
      } else if (now.isBefore(times.dhuhr)) {
        nextPrayer = Prayer.dhuhr;
      } else if (now.isBefore(times.asr)) {
        nextPrayer = Prayer.asr;
      } else if (now.isBefore(times.maghrib)) {
        nextPrayer = Prayer.maghrib;
      } else if (now.isBefore(times.isha)) {
        nextPrayer = Prayer.isha;
      } else {
        nextPrayer = Prayer.fajr; // Tomorrow's Fajr
      }
    }

    return Column(
      children: [
        PrayerListItem(name: 'Fajr', adhanTime: times.fajr, jamatTime: jamatTimes?[Prayer.fajr], prayer: Prayer.fajr, isNext: nextPrayer == Prayer.fajr),
        PrayerListItem(name: 'Sunrise', adhanTime: times.sunrise, isNext: false),
        PrayerListItem(name: 'Dhuhr', adhanTime: times.dhuhr, jamatTime: jamatTimes?[Prayer.dhuhr], prayer: Prayer.dhuhr, isNext: nextPrayer == Prayer.dhuhr),
        PrayerListItem(name: 'Asr', adhanTime: times.asr, jamatTime: jamatTimes?[Prayer.asr], prayer: Prayer.asr, isNext: nextPrayer == Prayer.asr),
        PrayerListItem(name: 'Maghrib', adhanTime: times.maghrib, jamatTime: jamatTimes?[Prayer.maghrib], prayer: Prayer.maghrib, isNext: nextPrayer == Prayer.maghrib),
        PrayerListItem(name: 'Isha', adhanTime: times.isha, jamatTime: jamatTimes?[Prayer.isha], prayer: Prayer.isha, isNext: nextPrayer == Prayer.isha),
      ],
    );
  }

  Widget _buildJummahCard(BuildContext context, List<String> jummahTimes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GardenPalette.lightGrey, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mosque, color: GardenPalette.gildedGold, size: 18),
              const SizedBox(width: 10),
              Text(
                'PÉNTEKI IMA',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: GardenPalette.nearBlack,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: jummahTimes.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: GardenPalette.gildedGold.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: GardenPalette.gildedGold.withAlpha(60)),
              ),
              child: Text(
                t,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: GardenPalette.gildedGold,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
