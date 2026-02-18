import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/garden_palette.dart';
import '../providers/selected_date_provider.dart';

class IslamicCalendarModal extends ConsumerStatefulWidget {
  const IslamicCalendarModal({super.key});

  @override
  ConsumerState<IslamicCalendarModal> createState() => _IslamicCalendarModalState();
}

class _IslamicCalendarModalState extends ConsumerState<IslamicCalendarModal> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = ref.read(selectedDateProvider);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: GardenPalette.offWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ISZLÁM NAPTÁR',
                  style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: GardenPalette.midnightForest),
                ),
                if (!isSameDay(selectedDate, DateTime.now()))
                  TextButton.icon(
                    onPressed: () {
                      final now = DateTime.now();
                      ref.read(selectedDateProvider.notifier).update(now);
                      setState(() => _focusedDay = now);
                    },
                    icon: Icon(Icons.today, size: 16, color: GardenPalette.emeraldTeal),
                    label: Text('Ma', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: GardenPalette.emeraldTeal)),
                    style: TextButton.styleFrom(
                      backgroundColor: GardenPalette.emeraldTeal.withAlpha(20),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: TableCalendar(
              locale: 'hu_HU', // Use Hungarian locale
              firstDay: DateTime.now().subtract(const Duration(days: 365 * 2)),
              lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                ref.read(selectedDateProvider.notifier).update(selectedDay);
                setState(() => _focusedDay = focusedDay);
                // We don't close modal immediately, allowing browsing
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: GardenPalette.emeraldTeal.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(color: GardenPalette.midnightForest, fontWeight: FontWeight.bold),
                selectedDecoration: BoxDecoration(
                  color: GardenPalette.midnightForest,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(color: GardenPalette.ivory, fontWeight: FontWeight.bold),
                cellMargin: const EdgeInsets.all(2),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold),
                leftChevronIcon: Icon(Icons.chevron_left, color: GardenPalette.gildedGold),
                rightChevronIcon: Icon(Icons.chevron_right, color: GardenPalette.gildedGold),
              ),
              calendarBuilders: CalendarBuilders(
                // Custom cell builder to show Hijri day below Gregorian
                defaultBuilder: (context, day, focusedDay) => _buildCell(day, false),
                selectedBuilder: (context, day, focusedDay) => _buildCell(day, true, isSelected: true),
                todayBuilder: (context, day, focusedDay) => _buildCell(day, true, isToday: true),
              ),
            ),
          ),
          
          // Selected Day Details
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,-2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('yyyy. MMMM d. (EEEE)', 'hu').format(selectedDate),
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: GardenPalette.midnightForest),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _hijriDateString(selectedDate),
                        style: GoogleFonts.playfairDisplay(fontSize: 14, color: GardenPalette.gildedGold, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GardenPalette.midnightForest,
                    foregroundColor: GardenPalette.ivory,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('KIVÁLASZT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(DateTime day, bool isFocused, {bool isSelected = false, bool isToday = false}) {
    final hijriDate = HijriCalendar.fromDate(day);
    
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isSelected ? GardenPalette.midnightForest : (isToday ? GardenPalette.emeraldTeal.withAlpha(40) : null),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? GardenPalette.ivory : Colors.black87,
            ),
          ),
          Text(
            '${hijriDate.hDay}',
            style: GoogleFonts.playfairDisplay(
              fontSize: 10,
              color: isSelected ? GardenPalette.ivory.withAlpha(180) : GardenPalette.gildedGold,
            ),
          ),
        ],
      ),
    );
  }

  String _hijriDateString(DateTime date) {
    final hDate = HijriCalendar.fromDate(date);
    // hDate.toFormat("dd MMMM yyyy") might default to English if not localized manually or via package.
    // hijri package supports localization but needs setup. For now, using English names or simplified format.
    // Ideally we'd map numerals or months to Hungarian.
    return '${hDate.hYear}. ${hDate.longMonthName} ${hDate.hDay}.'; 
  }
}
