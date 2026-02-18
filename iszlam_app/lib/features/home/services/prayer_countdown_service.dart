
import 'package:adhan/adhan.dart';
import '../../worship/models/prayer_time.dart';

class PrayerCountdownState {
  final Prayer nextPrayer;
  final DateTime nextPrayerTime;
  final Duration timeRemaining;
  final String nextPrayerName;

  PrayerCountdownState({
    required this.nextPrayer,
    required this.nextPrayerTime,
    required this.timeRemaining,
    required this.nextPrayerName,
  });

  String get formattedTimeRemaining {
    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes % 60;
    if (hours > 0) {
      return '$hoursó ${minutes}p';
    } else {
      return '$minutes perc';
    }
  }
}

class PrayerCountdownService {
  
  PrayerCountdownState calculateNextPrayer(DailyPrayerTimes today, DailyPrayerTimes tomorrow, DateTime now) {
    Prayer next = Prayer.none;
    DateTime? nextTime;

    // Check today's prayers
    if (now.isBefore(today.fajr)) {
      next = Prayer.fajr;
      nextTime = today.fajr;
    } else if (now.isBefore(today.sunrise)) {
      next = Prayer.sunrise;
      nextTime = today.sunrise;
    } else if (now.isBefore(today.dhuhr)) {
      next = Prayer.dhuhr;
      nextTime = today.dhuhr;
    } else if (now.isBefore(today.asr)) {
      next = Prayer.asr;
      nextTime = today.asr;
    } else if (now.isBefore(today.maghrib)) {
      next = Prayer.maghrib;
      nextTime = today.maghrib;
    } else if (now.isBefore(today.isha)) {
      next = Prayer.isha;
      nextTime = today.isha;
    }

    // If still null, it must be tomorrow's Fajr
    if (nextTime == null) {
      next = Prayer.fajr;
      nextTime = tomorrow.fajr;
    }

    final duration = nextTime.difference(now);

    return PrayerCountdownState(
      nextPrayer: next,
      nextPrayerTime: nextTime,
      timeRemaining: duration,
      nextPrayerName: _getPrayerName(next),
    );
  }

  String _getPrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr: return 'Fajr';
      case Prayer.sunrise: return 'Napkelte';
      case Prayer.dhuhr: return 'Dhuhr';
      case Prayer.asr: return 'Asr';
      case Prayer.maghrib: return 'Maghrib';
      case Prayer.isha: return 'Isha';
      case Prayer.none: return '';
    }
  }
}
