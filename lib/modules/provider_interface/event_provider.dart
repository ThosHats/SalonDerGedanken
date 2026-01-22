import 'package:salon_der_gedanken/core/models/event.dart';

abstract class EventProvider {
  String get id;
  String get displayName;
  String get description;
  Duration get defaultUpdateInterval;
  
  /// Fetches events from the provider.
  /// 
  /// [forceRefresh] - If true, bypass potentially stale caches if applicable within the provider logic itself,
  /// though usually caching is handled by the repository layer.
  Future<List<Event>> fetchEvents();
}
