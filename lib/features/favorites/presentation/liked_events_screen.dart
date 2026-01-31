import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_der_gedanken/core/models/event.dart';
import 'package:salon_der_gedanken/core/services/event_service.dart';
import 'package:salon_der_gedanken/core/providers/favorites_provider.dart';
import 'package:salon_der_gedanken/core/models/provider_config.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LikedEventsScreen extends ConsumerStatefulWidget {
  const LikedEventsScreen({super.key});

  @override
  ConsumerState<LikedEventsScreen> createState() => _LikedEventsScreenState();
}

class _LikedEventsScreenState extends ConsumerState<LikedEventsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _shouldScrollToNow = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Liked Events',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3211d4)),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
      ),
      body: eventsAsync.when(
        data: (events) {
          final likedEvents = events.where((e) => favorites.contains(e.id)).toList();
          
          if (likedEvents.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No liked events yet',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          // Sort chronological
          likedEvents.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

          // Auto-scroll logic to current time
          if (_shouldScrollToNow) {
            final now = DateTime.now();
            final firstFutureIndex = likedEvents.indexWhere((e) {
              final end = e.endDateTime ?? e.startDateTime.add(const Duration(hours: 1)); 
              return end.isAfter(now);
            });

            if (firstFutureIndex > 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                    // Approx item height + margin + padding
                    double offset = (firstFutureIndex * 105.0); // Estimate
                    
                    _scrollController.animateTo(
                      offset, 
                      duration: const Duration(milliseconds: 500), 
                      curve: Curves.easeOut,
                    );
                }
              });
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
               if(mounted) setState(() => _shouldScrollToNow = false);
            });
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: likedEvents.length,
            itemBuilder: (context, index) {
              final event = likedEvents[index];
              final isPast = event.endDateTime != null 
                  ? event.endDateTime!.isBefore(DateTime.now())
                  : event.startDateTime.add(const Duration(hours: 2)).isBefore(DateTime.now());

              return _LikedEventItem(event: event, isPast: isPast);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _LikedEventItem extends ConsumerWidget {
  final Event event;
  final bool isPast;
  const _LikedEventItem({required this.event, this.isPast = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('EEE, d MMM • HH:mm');
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
         color: isPast ? Colors.grey[200] : Colors.white,
         borderRadius: BorderRadius.circular(12),
         border: Border.all(color: Colors.grey[100]!),
      ),
      child: InkWell(
        onTap: () {
           context.push('/event/${event.id}', extra: event);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       children: [
                         Text(
                           dateFormat.format(event.startDateTime),
                           style: TextStyle(
                             color: isPast ? Colors.grey[500] : const Color(0xFF3211d4),
                             fontSize: 11,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         const SizedBox(width: 8),
                         Expanded(
                           child: Consumer(
                              builder: (context, ref, child) {
                                final providersAsync = ref.watch(eventProvidersProvider);
                                return providersAsync.when(
                                  data: (providers) {
                                    final provider = providers.firstWhere(
                                      (p) => p.id == event.providerId,
                                      orElse: () => ProviderConfig(
                                        id: event.providerId, 
                                        name: event.providerId, 
                                        enabled: true, 
                                        module: '', 
                                        updateInterval: ''
                                      ),
                                    );
                                    final displayName = provider.name ?? event.providerId;
                                    
                                    return Text(
                                      displayName,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  },
                                   loading: () => const SizedBox.shrink(),
                                   error: (_, __) => const SizedBox.shrink(),
                                );
                              }
                           ),
                         ),
                       ],
                     ),
                     const SizedBox(height: 4),
                     Text(
                       event.title,
                       style: TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.bold,
                         color: isPast ? Colors.grey[500] : const Color(0xFF0f172a),
                       ),
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                     ),
                     const SizedBox(height: 2),
                     Text(
                        event.locationName ?? event.address ?? 'Unknown Location',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                   ],
                 ),
               ),
               IconButton(
                 icon: const Icon(Icons.favorite, color: Colors.red),
                 onPressed: () {
                    // Remove from favorites
                    ref.read(favoritesProvider.notifier).toggleFavorite(event.id);
                 },
               ),
            ],
          ),
        ),
      ),
    );
  }
}
