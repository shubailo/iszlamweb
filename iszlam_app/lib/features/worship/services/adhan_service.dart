import 'package:adhan/adhan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prayer_time.dart';

final prayerTimesProvider = Provider.family<DailyPrayerTimes, Coordinates>((ref, coordinates) {
  return ref.watch(prayerTimesForDateProvider((coordinates, DateTime.now())));
});

final prayerTimesForDateProvider = Provider.family<DailyPrayerTimes, (Coordinates, DateTime)>((ref, params) {
  final coordinates = params.$1;
  final date = params.$2;
  
  final calculationParams = CalculationMethod.muslim_world_league.getParameters();
  calculationParams.madhab = Madhab.shafi;

  final prayerTimes = PrayerTimes(
    coordinates,
    DateComponents.from(date),
    calculationParams,
  );
  
  return DailyPrayerTimes.fromAdhan(prayerTimes, date);
});

// Budapest Coordinates (Default)
final defaultLocationProvider = Provider((ref) => Coordinates(47.4979, 19.0402));
