import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

// Simple model: Map<Prayer, bool> for today
class PrayerStatus {
  final Map<Prayer, bool> completed;

  const PrayerStatus({this.completed = const {}});

  bool isCompleted(Prayer prayer) => completed[prayer] ?? false;

  PrayerStatus copyWith({Map<Prayer, bool>? completed}) {
    return PrayerStatus(completed: completed ?? this.completed);
  }
}

// Provider for SharedPreferences instance
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// AsyncNotifier implementation (Riverpod 2.0+)
class PrayerTrackerNotifier extends AsyncNotifier<PrayerStatus> {

  // Initial state loading
  @override
  Future<PrayerStatus> build() async {
    return _loadStatus();
  }

  Future<PrayerStatus> _loadStatus() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    final Map<Prayer, bool> statusMap = {};
    for (final prayer in Prayer.values) {
      if (prayer == Prayer.none || prayer == Prayer.sunrise) continue;
      final key = 'prayer_status_${todayKey}_${prayer.name}';
      statusMap[prayer] = prefs.getBool(key) ?? false;
    }
    
    return PrayerStatus(completed: statusMap);
  }

  Future<void> togglePrayer(Prayer prayer) async {
    // Current state might be loading or error
    final currentState = state.value;
    if (currentState == null) return;

    final newStatus = !currentState.isCompleted(prayer);
    final newMap = Map<Prayer, bool>.from(currentState.completed);
    newMap[prayer] = newStatus;

    // Optimistic Update
    state = AsyncValue.data(currentState.copyWith(completed: newMap));

    // Persist
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final key = 'prayer_status_${todayKey}_${prayer.name}';
      await prefs.setBool(key, newStatus);
    } catch (e) {
      // Revert on error? For MVP, just log or ignore.
    }
  }
}

final prayerTrackerProvider = AsyncNotifierProvider<PrayerTrackerNotifier, PrayerStatus>(() {
  return PrayerTrackerNotifier();
});
