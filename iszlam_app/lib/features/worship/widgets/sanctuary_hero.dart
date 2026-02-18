import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/garden_palette.dart';
import '../../../core/localization/hungarian_strings.dart'; // Import H
import '../models/prayer_time.dart';

class SanctuaryHero extends StatelessWidget {
  final DailyPrayerTimes times;
  final DateTime selectedDate;
  final String nextPrayerName;
  final Duration countdown;

  const SanctuaryHero({
    super.key,
    required this.times,
    required this.selectedDate,
    required this.nextPrayerName,
    required this.countdown,
  });

  String _formatCountdown(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(selectedDate, DateTime.now());
    final hDate = HijriCalendar.fromDate(selectedDate);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GardenPalette.deepGreen,
            GardenPalette.leafyGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation & Header Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (MediaQuery.of(context).size.width <= 800)
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: Colors.white.withAlpha(180)),
                          const SizedBox(width: 4),
                          Text(
                            'Budapest, Magyarország',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: Colors.white.withAlpha(180),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${hDate.hYear}. ${hDate.longMonthName} ${hDate.hDay}.',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: GardenPalette.paleGold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (isToday) ...[
                // Next Prayer Label
                Text(
                  H.nextPrayer.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: GardenPalette.paleGold,
                  ),
                ),
                const SizedBox(height: 8),

                // Prayer Name
                Text(
                  nextPrayerName.isEmpty ? '...' : nextPrayerName.toUpperCase(),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),

                // Countdown Timer
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: GardenPalette.emeraldTeal.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: GardenPalette.emeraldTeal.withAlpha(50),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 20, color: GardenPalette.emeraldTeal),
                      const SizedBox(width: 10),
                      Text(
                        _formatCountdown(countdown),
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Future/Past Date View
                Text(
                  'KIVÁLASZTOTT DÁTUM', // TODO: Add to H
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: GardenPalette.paleGold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('MMMM d.', 'hu').format(selectedDate),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  DateFormat('EEEE', 'hu').format(selectedDate).toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.white.withAlpha(180),
                    letterSpacing: 4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    )
      .animate()
        .fadeIn(duration: 800.ms)
        .slideY(begin: -0.03, end: 0, duration: 600.ms);
  }
}
