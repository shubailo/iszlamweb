import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the selected date in the Sanctuary Dashboard.
class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void update(DateTime date) {
    state = date;
  }
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(() {
  return SelectedDateNotifier();
});
