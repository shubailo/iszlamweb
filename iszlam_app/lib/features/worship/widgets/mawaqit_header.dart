import 'package:flutter/material.dart';
import '../models/prayer_time.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/garden_palette.dart';

class MawaqitHeader extends StatelessWidget {
  final DailyPrayerTimes prayerTimes;
  final String nextEventName;
  final DateTime nextEventTime;

  const MawaqitHeader({
    super.key,
    required this.prayerTimes,
    required this.nextEventName,
    required this.nextEventTime,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeToNext = nextEventTime.difference(now);
    final hours = timeToNext.inHours;
    final minutes = timeToNext.inMinutes % 60;
    
    String countdownString;
    if (hours > 0) {
      countdownString = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else {
      countdownString = '$minutes perc'; // Hungarian for min
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Typographic Watermark (Architectural Depth)
        Positioned(
          bottom: -20,
          right: -10,
          child: Opacity(
            opacity: 0.03,
            child: Text(
              'IMA', // Hungarian for Prayer
              style: GoogleFonts.playfairDisplay(
                fontSize: 140,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),

        Container(
          width: double.infinity,
          height: 260,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [GardenPalette.deepGreen, GardenPalette.leafyGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location & Date (Asymmetric)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: GardenPalette.paleGold, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              "BUDAPEST",
                              style: GoogleFonts.outfit(
                                color: Colors.white, 
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          DateFormat('yyyy. MMM d., EEEE', 'hu').format(now).toUpperCase(),
                          style: GoogleFonts.outfit(
                            color: Colors.white.withAlpha(180), 
                            fontSize: 10,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Countdown (Vertical Asymmetry)
                Text(
                  nextEventName.toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: GardenPalette.paleGold,
                    fontSize: 12,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  countdownString,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 82,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -2.0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'múlik az imáig', // Hungarian for "until prayer"
                  style: GoogleFonts.outfit(
                    color: Colors.white.withAlpha(180),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
