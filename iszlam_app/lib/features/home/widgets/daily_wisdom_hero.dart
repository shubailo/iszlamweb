import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../providers/home_providers.dart';
import 'live_prayer_countdown.dart';

import 'package:hijri/hijri_calendar.dart';

class DailyWisdomHero extends ConsumerWidget {
  const DailyWisdomHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyContentAsync = ref.watch(dailyContentProvider);
    final hijriDate = HijriCalendar.now();
    final hijriString = "MF ${hijriDate.hYear}. ${hijriDate.getLongMonthName().toUpperCase()} ${hijriDate.hDay}.";

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Date Chip (Premium Minimal on Dark)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   const Icon(Icons.calendar_month, color: GardenPalette.ivory, size: 14),
                   const SizedBox(width: 8),
                   Text(
                     hijriString, 
                     style: GoogleFonts.outfit(
                       color: GardenPalette.ivory,
                       fontSize: 11,
                       fontWeight: FontWeight.w900,
                       letterSpacing: 1.2,
                     ),
                   ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. Main Title (White on Dark Green)
            Text(
              "Magyarországi\nMuszlimok Egyháza",
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 48,
                height: 1.1,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "A hit, a tudás és a közösség otthona minden kereső számára.",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: Colors.white.withAlpha(180),
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 48),
            const LivePrayerCountdown(),
            const SizedBox(height: 60),

            // 3. Glassmorphic Daily Wisdom Card
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    border: Border.all(color: Colors.white.withAlpha(40), width: 1),
                  ),
                  child: dailyContentAsync.when(
                    data: (content) => Column(
                      children: [
                        Text(
                          content.body,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 24,
                            height: 1.6,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 1,
                              width: 40,
                              color: Colors.white.withAlpha(60),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                content.source.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  color: Colors.white.withAlpha(180),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.5,
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: 40,
                              color: Colors.white.withAlpha(60),
                            ),
                          ],
                        ),
                      ],
                    ),
                    loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                    error: (_, _) => const Text('Hiba', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }


}
