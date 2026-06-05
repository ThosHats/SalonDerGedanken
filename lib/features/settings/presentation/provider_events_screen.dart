import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:salon_der_gedanken/core/models/event.dart';
import 'package:salon_der_gedanken/core/services/event_service.dart';

class ProviderEventsScreen extends ConsumerWidget {
  final String providerId;

  const ProviderEventsScreen({super.key, required this.providerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final providersAsync = ref.watch(eventProvidersProvider);

    final providerName = providersAsync.maybeWhen(
      data: (providers) {
        final matches = providers.where(
          (provider) => provider.id == providerId,
        );
        if (matches.isEmpty) return providerId;
        return matches.first.name ?? providerId;
      },
      orElse: () => providerId,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          providerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3211d4)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[100], height: 1.0),
        ),
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (events) {
          final providerEvents =
              events.where((event) => event.providerId == providerId).toList()
                ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

          if (providerEvents.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No events found',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: providerEvents.length,
            itemBuilder: (context, index) {
              return _ProviderEventItem(event: providerEvents[index]);
            },
          );
        },
      ),
    );
  }
}

class _ProviderEventItem extends StatelessWidget {
  final Event event;

  const _ProviderEventItem({required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, d MMM - HH:mm');
    final isPast =
        (event.endDateTime ?? event.startDateTime.add(const Duration(hours: 2)))
            .isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isPast ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/event/${event.id}', extra: event),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateFormat.format(event.startDateTime),
                style: TextStyle(
                  color: isPast ? Colors.grey[500] : const Color(0xFF3211d4),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                event.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isPast ? Colors.grey[500] : const Color(0xFF0f172a),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                event.locationName ?? event.address ?? 'Unknown Location',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
