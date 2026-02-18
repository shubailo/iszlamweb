import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mosque.dart';
import '../../worship/models/mosque_timing.dart';
import '../../worship/models/jamat_rule.dart';
import '../models/announcement.dart';

final mosqueListProvider = FutureProvider<List<Mosque>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));
  
  // Mock Data
  return [
    Mosque(
      id: '1',
      name: 'Budapest Grand Mosque',
      address: 'Fehérvári út 45',
      city: 'Budapest',
      imageUrl: 'https://images.unsplash.com/photo-1542361345-423048593674?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      timing: MosqueTiming(
        fajr: JamatRule.fixed("05:30"),
        dhuhr: JamatRule.offset(15), // Adhan + 15m
        asr: JamatRule.offset(10),
        maghrib: JamatRule.offset(5),
        isha: JamatRule.fixed("20:00"),
        jummahTimes: ["13:00"],
      ),
    ),
    const Mosque(
      id: '2',
      name: 'Debrecen Islamic Center',
      address: 'Piac utca 20',
      city: 'Debrecen',
    ),
    const Mosque(
      id: '3',
      name: 'Pécs Prayer House',
      address: 'Király utca 10',
      city: 'Pécs',
    ),
  ];
});

final selectedMosqueIdProvider = NotifierProvider<SelectedMosqueIdNotifier, String?>(SelectedMosqueIdNotifier.new);

class SelectedMosqueIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void update(String? newState) => state = newState;
}

final announcementsProvider = FutureProvider.family<List<Announcement>, String>((ref, mosqueId) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));

  // Mock Data
  return [
    Announcement(
      id: '1',
      mosqueId: mosqueId,
      title: 'Ramadan Preparation',
      content: 'We will be holding a community meeting this Friday to discuss Ramadan preparations.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Announcement(
      id: '2',
      mosqueId: mosqueId,
      title: 'New Carpet Installation',
      content: 'The new carpet has arrived! Volunteers needed for installation on Saturday.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Announcement(
      id: '3',
      mosqueId: mosqueId,
      title: 'Guest Speaker: Imam Abdullah',
      content: 'Join us for a special lecture on the importance of community brotherhood.',
      audioUrl: 'https://example.com/audio.mp3',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
});
