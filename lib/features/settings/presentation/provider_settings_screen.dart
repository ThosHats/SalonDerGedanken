import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salon_der_gedanken/core/services/event_service.dart';
import 'package:salon_der_gedanken/core/services/location_service.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_der_gedanken/features/settings/presentation/provider_events_screen.dart';

class ProviderSettingsScreen extends ConsumerStatefulWidget {
  const ProviderSettingsScreen({super.key});

  @override
  ConsumerState<ProviderSettingsScreen> createState() => _ProviderSettingsScreenState();
}

class _ProviderSettingsScreenState extends ConsumerState<ProviderSettingsScreen> {
  double _distance = 20.0;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final position = await LocationService().getCurrentLocation();
    if (mounted && position != null) {
      setState(() {
        _currentPosition = position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final providersAsyncValue = ref.watch(eventProvidersProvider);
    final enabledProviders = ref.watch(enabledProvidersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFf2f2f7), // iOS Grouped Background
      appBar: AppBar(
        title: const Text('Provider Management'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3211d4)),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'DISTANZ', // Changed from DISCOVERY RADIUS
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Distanz'), // Changed from Radius
                    Text('${_distance.round()} km', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)), // Changed value display
                  ],
                ),
                Slider(
                  value: _distance,
                  min: 1,
                  max: 20, // Changed max to 20
                  divisions: 19,
                  activeColor: const Color(0xFF3211d4),
                  onChanged: (val) {
                    setState(() {
                      _distance = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'NEARBY PROVIDERS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          
          providersAsyncValue.when(
            loading: () => const Center(child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            )),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (allProviders) {
               // Filter providers by distance
               final nearbyProviders = allProviders.where((provider) {
                 if (_currentPosition == null) return true; // Show all if location unknown? Or hide? 
                 // Assuming show all if location unknown to avoid empty screen
                 
                 if (provider.latitude == null || provider.longitude == null) {
                   return false; // Hide if no coordinates (per logic discussed)
                 }

                 final distanceInMeters = Geolocator.distanceBetween(
                   _currentPosition!.latitude, _currentPosition!.longitude, 
                   provider.latitude!, provider.longitude!
                 );
                 return (distanceInMeters / 1000) <= _distance;
               }).toList();

               if (nearbyProviders.isEmpty) {
                 return const Padding(
                   padding: EdgeInsets.all(32.0),
                   child: Center(child: Text('No providers found within this distance.', style: TextStyle(color: Colors.grey))),
                 );
               }

               return Container(
                color: Colors.white,
                child: Column(
                  children: nearbyProviders.map((provider) {
                    final isEnabled = enabledProviders == null 
                        ? true 
                        : enabledProviders.contains(provider.id);
                        
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          leading: Switch(
                            value: isEnabled,
                            activeColor: const Color(0xFF3211d4),
                            onChanged: (val) {
                              var current = ref.read(enabledProvidersProvider);
                              if (current == null) {
                                  current = allProviders.map((p) => p.id).toSet();
                              }
                              
                              if (val) {
                                ref.read(enabledProvidersProvider.notifier).state = {...current, provider.id};
                              } else {
                                ref.read(enabledProvidersProvider.notifier).state = current.difference({provider.id});
                              }
                            },
                          ),
                          title: Text(
                            provider.name ?? provider.id,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(provider.region ?? provider.address ?? 'Cloud Provider'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          onTap: () {
                             // Navigate to Provider Events Screen
                             Navigator.of(context).push(
                               MaterialPageRoute(
                                 builder: (context) => ProviderEventsScreen(providerId: provider.id),
                               ),
                             );
                          },
                        ),
                        if (provider != nearbyProviders.last)
                          const Divider(height: 1, indent: 60),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
