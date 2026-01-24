import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_der_gedanken/core/models/event.dart';
import 'package:salon_der_gedanken/core/providers/favorites_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsScreen extends ConsumerWidget {
  final Event? event;
  final String? eventId;

  const EventDetailsScreen({super.key, this.event, this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, if event is null, fetch it by ID using a provider
    if (event == null) {
      return const Scaffold(
        body: Center(child: Text('Event not found')),
      );
    }

    final e = event!;
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(e.id);
    
    final dateFormat = DateFormat('EEEE, d MMMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3211d4), size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : const Color(0xFF3211d4),
            ),
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggleFavorite(e.id);
            },
          ),
          const SizedBox(width: 8),
        ],
        title: const Text(
          'Event Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
         bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              e.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0f172a),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            
            // Tags/Categories
            Wrap(
              spacing: 8,
              children: [
                _Tag(label: 'Philosophy', color: Colors.indigo),
                if (e.isFree)
                  const _Tag(label: 'Free of Charge', color: Colors.green),
              ],
            ),
             const SizedBox(height: 24),

            // Info Rows
            _InfoRow(
              icon: Icons.calendar_today,
              text: dateFormat.format(e.startDateTime),
              subtext: '${timeFormat.format(e.startDateTime)} - ${e.endDateTime != null ? timeFormat.format(e.endDateTime!) : 'Open end'}',
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.location_on,
              text: e.locationName ?? 'Unknown Location',
              subtext: e.address,
            ),
             const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.store,
              text: 'Host: ${e.providerId}', // Map ID to name in real app
              subtext: 'Weekly series',
            ),

            const SizedBox(height: 32),
            const Divider(),
             const SizedBox(height: 24),

            // Description
            const Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (e.description != null)
              Text(
                e.description!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF475569),
                  height: 1.6,
                ),
              ),
             if (e.longDescription != null) ...[
              const SizedBox(height: 12),
               Text(
              e.longDescription!,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF475569),
                height: 1.6,
              ),
            ),
             ],


              if (e.url.isNotEmpty) ...[
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse(e.url);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                         debugPrint('Could not launch $url');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3211d4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Visit Website',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final MaterialColor color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.shade100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.shade700,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? subtext;

  const _InfoRow({required this.icon, required this.text, this.subtext});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.indigo, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0f172a),
                ),
              ),
              if (subtext != null)
                Text(
                  subtext!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748b),
                    height: 1.4,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
