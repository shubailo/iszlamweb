import 'package:adhan/adhan.dart';
import '../models/jamat_rule.dart';
import '../models/mosque_timing.dart';

class JamatCalculator {
  
  /// Calculates the specific Jamat time for a single prayer based on the rule.
  static DateTime calculateJamatTime(DateTime adhanTime, JamatRule rule) {
    switch (rule.type) {
      case JamatType.fixed:
        if (rule.fixedTime == null) return adhanTime;
        final parts = rule.fixedTime!.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        
        final now = DateTime.now();
        // Create a time for today at the fixed hour/minute
        var fixedDateTime = DateTime(now.year, now.month, now.day, hour, minute);
        
        // If fixed time is earlier than Adhan (edge case), it probably means it's set for tomorrow? 
        // Or maybe just a data error. For now, we assume it's for the current day.
        return fixedDateTime;
        
      case JamatType.offset:
        if (rule.offsetMinutes == null) return adhanTime;
        return adhanTime.add(Duration(minutes: rule.offsetMinutes!));
        
      case JamatType.dynamic:
        // Placeholder for complex logic (e.g. "Maghrib + 5 unless...").
        // For now, treat as +10 mins default
        return adhanTime.add(const Duration(minutes: 10));
    }
  }

  /// Returns a Map of prayer names to their Jamat DateTimes.
  static Map<Prayer, DateTime> calculateAllJamatTimes(PrayerTimes prayerTimes, MosqueTiming timing) {
    return {
      Prayer.fajr: calculateJamatTime(prayerTimes.fajr, timing.fajr),
      Prayer.dhuhr: calculateJamatTime(prayerTimes.dhuhr, timing.dhuhr),
      Prayer.asr: calculateJamatTime(prayerTimes.asr, timing.asr),
      Prayer.maghrib: calculateJamatTime(prayerTimes.maghrib, timing.maghrib),
      Prayer.isha: calculateJamatTime(prayerTimes.isha, timing.isha),
    };
  }
}
