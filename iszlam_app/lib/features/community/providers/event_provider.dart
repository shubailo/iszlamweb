import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mosque_event.dart';
import '../models/announcement.dart';

final mosqueEventsProvider = FutureProvider.family<List<MosqueEvent>, String>((ref, mosqueId) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 800));

  // Mock Data
  return [
    MosqueEvent(
      id: '1',
      mosqueId: mosqueId,
      title: 'Community Iftar',
      description: 'Join us for a community Iftar this Friday. Please bring a dish to share!',
      startTime: DateTime.now().add(const Duration(days: 2, hours: 18)),
      endTime: DateTime.now().add(const Duration(days: 2, hours: 20)),
      location: 'Main Hall',
      requiresRegistration: true,
      imageUrl: 'https://images.unsplash.com/photo-1519817650390-64a93db51149?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    ),
    MosqueEvent(
      id: '2',
      mosqueId: mosqueId,
      title: 'Weekly Quran Halaqa',
      description: 'Brother Ahmed will be leading the Tafseer of Surah Al-Kahf.',
      startTime: DateTime.now().add(const Duration(days: 4, hours: 19)),
      location: 'Library',
      requiresRegistration: false,
    ),
    MosqueEvent(
      id: '3',
      mosqueId: mosqueId,
      title: 'Youth Soccer Match',
      description: 'Sisters vs Brothers (Separate fields).',
      startTime: DateTime.now().add(const Duration(days: 6, hours: 10)),
      location: 'City Park',
      requiresRegistration: true,
    ),
  ];
});

final announcementsProvider = FutureProvider.family<List<Announcement>, String>((ref, mosqueId) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return [
    Announcement(
      id: '1',
      mosqueId: mosqueId,
      title: 'Ramadán felkészülés',
      content: 'Holnap este közös előadás a Ramadánra való felkészülésről. Minden érdeklődőt szeretettel várunk!',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      audioUrl: 'https://example.com/audio.mp3',
    ),
    Announcement(
      id: '2',
      mosqueId: mosqueId,
      title: 'Adománygyűjtés',
      content: 'A mecset felújítására adományokat gyűjtünk. Kérjük, támogassa közösségünket lehetőségeihez mérten.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
});
