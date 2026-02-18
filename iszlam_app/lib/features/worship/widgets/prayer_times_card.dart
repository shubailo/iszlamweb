import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/garden_palette.dart';
import '../models/prayer_time.dart';
import '../providers/selected_date_provider.dart';

class PrayerTimesCard extends ConsumerWidget {
  final DailyPrayerTimes times;
  final String nextPrayerName;

  const PrayerTimesCard({
    super.key,
    required this.times,
    required this.nextPrayerName,
  });

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayers = [
      ('Fadzsr', times.fajr),
      ('Napkelte', times.sunrise),
      ('Dhuhr', times.dhuhr),
      ('Aszr', times.asr),
      ('Maghrib', times.maghrib),
      ('Isa', times.isha),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: GardenPalette.white.withAlpha(12),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Icon(Icons.mosque,
                      size: 18, color: GardenPalette.leafyGreen),
                  const SizedBox(width: 8),
                  Text(
                    'IMAIDŐK - ${DateFormat('MM.dd.').format(ref.read(selectedDateProvider))}',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: GardenPalette.nearBlack.withAlpha(130),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.push('/worship'),
                    child: Text(
                      'Részletek',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: GardenPalette.leafyGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ...prayers.map((p) {
              final isNext = p.$1 == nextPrayerName && DateUtils.isSameDay(ref.read(selectedDateProvider), DateTime.now());
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: isNext
                      ? GardenPalette.leafyGreen.withAlpha(8)
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    if (isNext)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: GardenPalette.leafyGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (!isNext) const SizedBox(width: 16),
                    Text(
                      p.$1,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight:
                            isNext ? FontWeight.w700 : FontWeight.w500,
                        color: isNext
                            ? GardenPalette.leafyGreen
                            : GardenPalette.nearBlack,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatTime(p.$2),
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight:
                            isNext ? FontWeight.w700 : FontWeight.w500,
                        color: isNext
                            ? GardenPalette.leafyGreen
                            : GardenPalette.nearBlack.withAlpha(150),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
