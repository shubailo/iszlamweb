import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../core/theme/garden_palette.dart';
import '../providers/calendar_provider.dart';

class WeekCalendarStrip extends ConsumerStatefulWidget {
  const WeekCalendarStrip({super.key});

  @override
  ConsumerState<WeekCalendarStrip> createState() => _WeekCalendarStripState();
}

class _WeekCalendarStripState extends ConsumerState<WeekCalendarStrip> {
  late PageController _pageController;
  static const int _initialPage = 500; // Center page for infinite scroll

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _weekStartForPage(int page) {
    final today = DateTime.now();
    final todayWeekStart = today.subtract(Duration(days: today.weekday - 1));
    final offset = page - _initialPage;
    return todayWeekStart.add(Duration(days: offset * 7));
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final hijri = HijriCalendar.fromDate(selectedDate);
    final hijriStr = '${hijri.hDay} ${_hijriMonthName(hijri.hMonth)} ${hijri.hYear}';

    return Column(
      children: [
        // Month + Hijri header with navigation arrows
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: GardenPalette.nearBlack, size: 22),
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      DateFormat('yyyy MMMM', 'hu').format(selectedDate),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: GardenPalette.nearBlack,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hijriStr,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: GardenPalette.leafyGreen.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: GardenPalette.nearBlack, size: 22),
                onPressed: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              // Today button
              GestureDetector(
                onTap: () {
                  ref.read(selectedDateProvider.notifier).select(DateTime.now());
                  _pageController.animateToPage(
                    _initialPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: GardenPalette.leafyGreen.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.today, color: GardenPalette.leafyGreen, size: 18),
                ),
              ),
            ],
          ),
        ),

        // Week strip (swipable pages)
        SizedBox(
          height: 72,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              // Auto-select first day of new week if current selection is outside
              final weekStart = _weekStartForPage(page);
              final selected = ref.read(selectedDateProvider);
              if (selected.isBefore(weekStart) || selected.isAfter(weekStart.add(const Duration(days: 6)))) {
                ref.read(selectedDateProvider.notifier).select(weekStart);
              }
            },
            itemBuilder: (context, page) {
              final weekStart = _weekStartForPage(page);
              return _buildWeekRow(weekStart, selectedDate);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeekRow(DateTime weekStart, DateTime selectedDate) {
    final today = DateTime.now();
    final dayNames = ['H', 'K', 'Sze', 'Cs', 'P', 'Szo', 'V']; // Hungarian day abbreviations

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (i) {
        final day = weekStart.add(Duration(days: i));
        final isSelected = _isSameDay(day, selectedDate);
        final isToday = _isSameDay(day, today);
        final isFriday = day.weekday == 5;

        return GestureDetector(
          onTap: () {
            ref.read(selectedDateProvider.notifier).select(day);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? GardenPalette.leafyGreen
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isToday && !isSelected
                  ? Border.all(color: GardenPalette.leafyGreen.withValues(alpha: 0.5))
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayNames[i],
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? GardenPalette.lightGrey
                        : (isFriday ? GardenPalette.leafyGreen : GardenPalette.darkGrey),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${day.day}',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected
                        ? GardenPalette.lightGrey
                        : GardenPalette.nearBlack,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _hijriMonthName(int month) {
    const months = [
      '', 'Muharram', 'Safar', "Rabí' al-Avval", "Rabí' ath-Thání",
      "Dzsumádá al-Úlá", "Dzsumádá ath-Thánija", 'Radzsab', "Sa'bán",
      'Ramadán', 'Savvál', "Dhul-Qi'da", 'Dhul-Hiddzsah',
    ];
    return (month >= 1 && month <= 12) ? months[month] : '';
  }
}
