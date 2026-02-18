import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../../core/theme/garden_palette.dart';
import '../../worship/services/adhan_service.dart';
import '../services/prayer_countdown_service.dart';

class LivePrayerCountdown extends ConsumerStatefulWidget {
  const LivePrayerCountdown({super.key});

  @override
  ConsumerState<LivePrayerCountdown> createState() => _LivePrayerCountdownState();
}

class _LivePrayerCountdownState extends ConsumerState<LivePrayerCountdown> {
  Timer? _timer;
  final _service = PrayerCountdownService();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(defaultLocationProvider);
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final tomorrowDate = todayDate.add(const Duration(days: 1));

    final todayPrayers = ref.watch(prayerTimesForDateProvider((location, todayDate)));
    final tomorrowPrayers = ref.watch(prayerTimesForDateProvider((location, tomorrowDate)));

    final state = _service.calculateNextPrayer(todayPrayers, tomorrowPrayers, now);

    return Column(
      children: [
        Text(
          'KÖVETKEZŐ IMA: ${state.nextPrayerName}'.toUpperCase(),
          style: GoogleFonts.outfit(
            color: GardenPalette.gildedGold.withAlpha(200),
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          state.formattedTimeRemaining,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 28, // Increased size for hero impact (Mi-raj style)
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black.withAlpha(76),
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        // Optional: Add "Time" like Mi-raj
        const SizedBox(height: 4),
         Text(
          "${state.nextPrayerTime.hour.toString().padLeft(2, '0')}:${state.nextPrayerTime.minute.toString().padLeft(2, '0')}",
          style: GoogleFonts.outfit(
            color: Colors.white.withAlpha(178),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
