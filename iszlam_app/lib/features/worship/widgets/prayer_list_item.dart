import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import '../providers/prayer_tracker_provider.dart';
import '../../../core/theme/garden_palette.dart';

class PrayerListItem extends ConsumerWidget {
  final String name;
  final DateTime adhanTime;
  final DateTime? jamatTime;
  final Prayer? prayer;
  final bool isNext;

  const PrayerListItem({
    super.key,
    required this.name,
    required this.adhanTime,
    this.jamatTime,
    this.prayer,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted = prayer != null
        ? ref.watch(prayerTrackerProvider).value?.isCompleted(prayer!) ?? false
        : false;

    final isPast = DateTime.now().isAfter(adhanTime) && !isNext;
    final iqamaOffset = jamatTime != null
        ? '+${jamatTime!.difference(adhanTime).inMinutes}'
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: isNext
            ? GardenPalette.leafyGreen.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isNext
            ? Border.all(color: GardenPalette.leafyGreen.withValues(alpha: 0.3))
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: prayer != null
              ? () => ref.read(prayerTrackerProvider.notifier).togglePrayer(prayer!)
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Prayer name
                SizedBox(
                  width: 80,
                  child: Text(
                    name,
                    style: GoogleFonts.outfit(
                      fontSize: isNext ? 16 : 14,
                      fontWeight: isNext ? FontWeight.w800 : FontWeight.w500,
                      color: isNext
                          ? GardenPalette.leafyGreen
                          : (isPast
                              ? GardenPalette.darkGrey.withValues(alpha: 0.5)
                              : GardenPalette.nearBlack.withValues(alpha: 0.8)),
                    ),
                  ),
                ),

                // Adhan time (large)
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        DateFormat('HH:mm').format(adhanTime),
                        style: GoogleFonts.playfairDisplay(
                          fontSize: isNext ? 28 : 22,
                          fontWeight: FontWeight.bold,
                          color: isNext
                              ? GardenPalette.leafyGreen
                              : (isPast
                                  ? GardenPalette.darkGrey.withValues(alpha: 0.4)
                                  : GardenPalette.nearBlack),
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (iqamaOffset != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          iqamaOffset,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isNext
                                ? GardenPalette.leafyGreen.withValues(alpha: 0.7)
                                : GardenPalette.darkGrey.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Action: Check or Notification icon
                if (prayer != null)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? GardenPalette.leafyGreen.withValues(alpha: 0.15)
                          : GardenPalette.white.withValues(alpha: 0.5),
                    ),
                    child: Icon(
                      isCompleted
                          ? Icons.check_circle
                          : Icons.notifications_none,
                      color: isCompleted
                          ? GardenPalette.leafyGreen
                          : GardenPalette.darkGrey.withValues(alpha: 0.4),
                      size: 18,
                    ),
                  )
                else
                  const SizedBox(width: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
