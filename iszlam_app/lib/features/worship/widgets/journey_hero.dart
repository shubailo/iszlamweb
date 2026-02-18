import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../core/theme/garden_palette.dart';
import '../models/user_journey.dart';

class JourneyHero extends StatelessWidget {
  final UserJourney journey;
  final DateTime selectedDate;

  const JourneyHero({
    super.key,
    required this.journey,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final hDate = HijriCalendar.fromDate(selectedDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 32),
      decoration: const BoxDecoration(
        color: GardenPalette.midnightGreen, // Sophisticated dark background
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ÜDVÖZÖLJÜK',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                          color: GardenPalette.paleGold,
                        ),
                      ),
                      Text(
                        'Az Ön útja',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  if (MediaQuery.of(context).size.width <= 800)
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Date Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withAlpha(40)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: GardenPalette.paleGold),
                    const SizedBox(width: 8),
                    Text(
                      '${hDate.hYear}. ${hDate.longMonthName} ${hDate.hDay}.',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Colors.white.withAlpha(220),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Summary metric
              Row(
                children: [
                  _Metric(
                    value: journey.consecutivePrayerDays.toString(),
                    label: 'nap folyamatosan',
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
    .animate()
    .fadeIn(duration: 800.ms)
    .slideY(begin: -0.05, end: 0, duration: 600.ms);
  }
}

class _Metric extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _Metric({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1,
              ),
            ),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white.withAlpha(150),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
