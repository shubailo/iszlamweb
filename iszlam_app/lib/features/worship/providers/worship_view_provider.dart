import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WorshipView { sanctuary, prayerTimes, quran, duas, qibla, tasbih, names99 }

class WorshipViewNotifier extends Notifier<WorshipView> {
  @override
  WorshipView build() => WorshipView.sanctuary;

  void select(WorshipView view) => state = view;
}

final worshipViewProvider =
    NotifierProvider<WorshipViewNotifier, WorshipView>(WorshipViewNotifier.new);
