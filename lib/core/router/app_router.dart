
import 'package:go_router/go_router.dart';
import 'package:salon_der_gedanken/core/models/event.dart';
import 'package:salon_der_gedanken/features/discovery/presentation/discovery_screen.dart';
import 'package:salon_der_gedanken/features/event_details/presentation/event_details_screen.dart';
import 'package:salon_der_gedanken/features/settings/presentation/provider_settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DiscoveryScreen(),
    ),
    GoRoute(
      path: '/event/:id',
      builder: (context, state) {
        final event = state.extra as Event?;
        final eventId = state.pathParameters['id'];
        return EventDetailsScreen(event: event, eventId: eventId);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const ProviderSettingsScreen(),
    ),
  ],
);
