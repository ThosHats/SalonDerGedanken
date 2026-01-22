import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_der_gedanken/core/models/event.dart';
import 'package:salon_der_gedanken/modules/provider_interface/event_provider.dart';
import 'package:salon_der_gedanken/modules/providers/echtzeitmusik/echtzeitmusik_provider.dart';

// Registry of available providers
final eventProvidersProvider = Provider<List<EventProvider>>((ref) {
  return [
    EchtzeitmusikProvider(),
  ];
});

// State provider for enabled providers (Set of IDs)
final enabledProvidersProvider = StateProvider<Set<String>>((ref) {
  // Default all enabled
  final providers = ref.watch(eventProvidersProvider);
  return providers.map((p) => p.id).toSet();
});

// Future provider that fetches events from all enabled providers
final eventsProvider = FutureProvider<List<Event>>((ref) async {
  final providers = ref.watch(eventProvidersProvider);
  final enabledIds = ref.watch(enabledProvidersProvider);
  final allEvents = <Event>[];

  for (final provider in providers) {
    if (!enabledIds.contains(provider.id)) continue;
    
    try {
      final events = await provider.fetchEvents();
      allEvents.addAll(events);
    } catch (e) {
      // Handle error gracefully - maybe log it
      // log('Error fetching from ${provider.displayName}: $e');
    }
  }

  // Sort by date
  allEvents.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  
  return allEvents;
});
