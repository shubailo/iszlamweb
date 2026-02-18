import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mosque_group.dart';
import '../models/mosque.dart';

final mosqueGroupsProvider = FutureProvider.family<List<MosqueGroup>, String>((ref, mosqueId) async {
  await Future.delayed(const Duration(milliseconds: 600));

  final now = DateTime.now();

  return [
    MosqueGroup(
      id: '1',
      mosqueId: mosqueId,
      name: 'Brothers Quran Circle',
      description: 'Weekly gathering to recite and reflect on the Quran.',
      leaderName: 'Imam Hassan',
      meetingTime: 'Wednesdays after Maghrib',
      imageUrl: 'https://images.unsplash.com/photo-1609599006353-e629aaabfeae?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      createdAt: now,
      updatedAt: now,
    ),
    MosqueGroup(
      id: '2',
      mosqueId: mosqueId,
      name: 'Sisters Book Club',
      description: 'Reading "Reclaim Your Heart" by Yasmin Mogahed.',
      leaderName: 'Sister Fatima',
      meetingTime: 'Saturdays at 11:00 AM',
      createdAt: now,
      updatedAt: now,
    ),
    MosqueGroup(
      id: '3',
      mosqueId: mosqueId,
      name: 'New Muslims Support',
      description: 'A safe space for new converts to learn and ask questions.',
      leaderName: 'Brother Yusuf',
      meetingTime: 'Sundays at 2:00 PM',
      privacyType: CommunityPrivacyType.private,
      createdAt: now,
      updatedAt: now,
    ),
  ];
});
