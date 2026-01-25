import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_der_gedanken/core/models/event.dart';
import 'package:salon_der_gedanken/core/models/provider_config.dart';
import 'package:salon_der_gedanken/core/services/event_api_service.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return EventsRepository(EventApiService());
});

class EventsRepository {
  final EventApiService _apiService;
  static const String _eventsBoxName = 'events_cache';
  static const String _metadataBoxName = 'events_metadata';
  static const String _lastUpdatedKey = 'last_updated';

  EventsRepository(this._apiService);

  Future<void> init() async {
    if (!Hive.isBoxOpen(_eventsBoxName)) {
      await Hive.openBox<Event>(_eventsBoxName);
    }
    if (!Hive.isBoxOpen(_metadataBoxName)) {
      await Hive.openBox(_metadataBoxName);
    }
  }

  Future<List<Event>> getEvents({bool forceRefresh = false}) async {
    await init();
    final eventsBox = Hive.box<Event>(_eventsBoxName);
    final metadataBox = Hive.box(_metadataBoxName);

    final lastUpdated = metadataBox.get(_lastUpdatedKey) as DateTime?;
    final now = DateTime.now();
    final isCacheStale = lastUpdated == null || 
                         lastUpdated.year != now.year || 
                         lastUpdated.month != now.month || 
                         lastUpdated.day != now.day;

    if (forceRefresh || isCacheStale) {
      try {
        final now = DateTime.now();
        final startDate = now.toIso8601String().substring(0, 10);
        // Fetch specific range (14 days as shown in UI)
        final endDate = now.add(const Duration(days: 14)).toIso8601String().substring(0, 10);

        final events = await _apiService.getEvents(
          from: startDate,
          to: endDate,
        );
        
        // Clear old cache and save new events
        await eventsBox.clear();
        await eventsBox.addAll(events);
        
        // Update timestamp
        await metadataBox.put(_lastUpdatedKey, now);
        
        return events;
      } catch (e) {
        // If fetch fails, try to return cached events if available
        if (eventsBox.isNotEmpty) {
          return eventsBox.values.toList();
        }
        rethrow;
      }
    } else {
      return eventsBox.values.toList();
    }
  }

  Future<List<ProviderConfig>> getProviders() async {
    // For now we don't cache providers heavily, or we could also cache them.
    // The requirement specified events caching specifically.
    return _apiService.getProviders();
  }
}
