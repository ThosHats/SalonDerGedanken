import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_der_gedanken/core/models/event.dart';
import 'package:salon_der_gedanken/core/models/provider_config.dart';
import 'package:salon_der_gedanken/core/repositories/events_repository.dart';

// Future provider that fetches available providers from API
final eventProvidersProvider = FutureProvider<List<ProviderConfig>>((ref) async {
  final repository = ref.watch(eventsRepositoryProvider);
  return repository.getProviders();
});

// State provider for enabled providers (Set of IDs)
final enabledProvidersProvider = StateProvider<Set<String>?>((ref) {
  return null; // null implies "all enabled" (default)
});

// Future provider that fetches events from API (via repository)
// and filters them based on enabled providers.
final eventsProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.read(eventsRepositoryProvider);
  
  final events = await repository.getEvents(); 

  final enabledIds = ref.watch(enabledProvidersProvider);
  
  // If null, all are enabled by default
  if (enabledIds == null) {
     return events;
  }
  
  return events.where((e) => enabledIds.contains(e.providerId)).toList();
});

// Helper to force refresh events from network
final refreshEventsProvider = FutureProvider<void>((ref) async {
  final repository = ref.read(eventsRepositoryProvider);
  await repository.getEvents(forceRefresh: true);
  // After forcing refresh in repo, invalidating eventsProvider will re-read the updated cache
  ref.invalidate(eventsProvider);
});
