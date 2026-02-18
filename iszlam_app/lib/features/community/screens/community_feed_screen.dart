import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/hungarian_strings.dart';
import '../providers/mosque_provider.dart';
import '../providers/event_provider.dart';
import '../models/announcement.dart';
import '../../admin_tools/screens/quick_post_screen.dart';
import 'events_list_screen.dart';
import 'groups_list_screen.dart';
import 'mosque_map_screen.dart';

import '../../auth/widgets/community_auth_guard.dart';

class CommunityFeedScreen extends ConsumerWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommunityAuthGuard(
      child: Builder(
        builder: (context) {
          final selectedMosqueId = ref.watch(selectedMosqueIdProvider);
          final mosqueListAsync = ref.watch(mosqueListProvider);

          if (selectedMosqueId == null) {
            return Scaffold(
              appBar: AppBar(title: const Text(H.selectMosque)),
              body: mosqueListAsync.when(
                data: (mosques) => ListView.builder(
                  itemCount: mosques.length,
                  itemBuilder: (context, index) {
                    final mosque = mosques[index];
                    return ListTile(
                      title: Text(mosque.name),
                      subtitle: Text('${mosque.address}, ${mosque.city}'),
                      onTap: () {
                        ref.read(selectedMosqueIdProvider.notifier).update(mosque.id);
                      },
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            );
          }

          final announcementsAsync = ref.watch(announcementsProvider(selectedMosqueId));

          return Scaffold(
            appBar: AppBar(
              title: const Text(H.communityFeed),
              actions: [
                IconButton(
                  icon: const Icon(Icons.map_outlined),
                  tooltip: 'Mecsetkereső',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MosqueMapScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  tooltip: 'Events',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventsListScreen(mosqueId: selectedMosqueId),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.group),
                  tooltip: 'Groups',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupsListScreen(mosqueId: selectedMosqueId),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  tooltip: 'Change Mosque',
                  onPressed: () => ref.read(selectedMosqueIdProvider.notifier).update(null),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuickPostScreen()),
              ),
              child: const Icon(Icons.add),
            ),
            body: announcementsAsync.when(
              data: (announcements) {
                if (announcements.isEmpty) {
                  return const Center(child: Text(H.noAnnouncements));
                }
                return ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final item = announcements[index];
                    return AnnouncementCard(announcement: item);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          );
        },
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).primaryColor.withAlpha(13)), // 0.05 * 255 ~ 13
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withAlpha(26), // 0.1 * 255 ~ 26
                  radius: 16,
                  child: Icon(Icons.mosque, size: 16, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    announcement.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              announcement.content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            if (announcement.audioUrl != null) ...[
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withAlpha(13), // 0.05 * 255 ~ 13
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.play_circle_fill, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      H.listenAudio,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              DateFormat('yyyy. MMM. dd.').format(announcement.createdAt),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
