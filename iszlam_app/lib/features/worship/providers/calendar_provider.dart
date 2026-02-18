import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void select(DateTime date) => state = date;
  void reset() => state = DateTime.now();
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);
