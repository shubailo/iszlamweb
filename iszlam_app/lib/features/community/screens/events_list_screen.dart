import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/event_provider.dart';
import '../models/mosque_event.dart';

class EventsListScreen extends ConsumerWidget {
  final String mosqueId;
  const EventsListScreen({super.key, required this.mosqueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(mosqueEventsProvider(mosqueId));

    return Scaffold(
      appBar: AppBar(title: const Text('Community Events')),
      body: eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return const Center(child: Text('No upcoming events.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return EventCard(event: events[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final MosqueEvent event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: Open detail view
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.imageUrl != null)
              Image.network(
                event.imageUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, size: 50)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withAlpha(26), // 0.1 * 255
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          DateFormat.MMMd().format(event.startTime),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (event.requiresRegistration)
                        Chip(
                          label: const Text('Registration Open', style: TextStyle(fontSize: 10)),
                          backgroundColor: Theme.of(context).colorScheme.secondary.withAlpha(51), // 0.2 * 255
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat.jm().format(event.startTime),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        event.location,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
