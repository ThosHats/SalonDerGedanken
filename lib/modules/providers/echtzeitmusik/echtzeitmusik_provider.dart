import 'package:salon_der_gedanken/core/models/event.dart';
import 'package:salon_der_gedanken/modules/provider_interface/event_provider.dart';

class EchtzeitmusikProvider implements EventProvider {
  @override
  String get id => 'echtzeitmusik';

  @override
  String get displayName => 'Echtzeitmusik';

  @override
  String get description => 'Berlin experimental music calendar';

  @override
  Duration get defaultUpdateInterval => const Duration(hours: 6);

  @override
  Future<List<Event>> fetchEvents() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final now = DateTime.now();
    
    return [
      Event(
        id: 'ezm-1',
        title: 'Improvised Soundscapes',
        description: 'An evening of experimental electronics and acoustic improvisation.',
        startDateTime: DateTime(now.year, now.month, now.day, 20, 0),
        endDateTime: DateTime(now.year, now.month, now.day, 22, 0),
        locationName: 'Ausland',
        address: 'Lychener Str. 60, 10437 Berlin',
        providerId: id,
        url: 'https://example.com',
        priceText: '10-15€',
      ),
      Event(
        id: 'ezm-2',
        title: 'Minimalist Compositions',
        description: 'Works for piano and silence.',
        startDateTime: DateTime(now.year, now.month, now.day, 19, 30),
        locationName: 'KM28',
        address: 'Karl-Marx-Straße 28, 12043 Berlin',
        providerId: id,
        url: 'https://example.com',
        isFree: true,
      ),
      Event(
        id: 'ezm-3',
        title: 'Noise & Texture',
        description: 'High volume warning.',
        startDateTime: DateTime(now.year, now.month, now.day + 1, 21, 0),
        locationName: 'Loophole',
        providerId: id,
        url: 'https://example.com',
        priceText: '8€',
      ),
       Event(
        id: 'ezm-4',
        title: 'Philosophical Jazz',
        description: 'Jazz meets Heidegger.',
        startDateTime: DateTime(now.year, now.month, now.day + 1, 20, 0),
        locationName: 'Donau115',
        providerId: id,
        url: 'https://example.com',
        priceText: 'Donation based',
      ),
        Event(
        id: 'ezm-5',
        title: 'Electro-Acoustic Session',
        description: 'Exploration of sound boundaries.',
        startDateTime: DateTime(now.year, now.month, now.day + 2, 20, 30),
        locationName: 'Sowsesso',
        providerId: id,
        url: 'https://example.com',
        priceText: '10€',
      ),
    ];
  }
}
