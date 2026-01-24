import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_der_gedanken/core/services/event_service.dart';
import 'package:go_router/go_router.dart';

class ProviderSettingsScreen extends ConsumerWidget {
  const ProviderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              'DISCOVERY RADIUS',
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
                    const Text('Radius'),
                    Text('25 km', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: 25,
                  min: 5,
                  max: 100,
                  activeColor: const Color(0xFF3211d4),
                  onChanged: (val) {},
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
               return Container(
                color: Colors.white,
                child: Column(
                  children: allProviders.map((provider) {
                    final isEnabled = enabledProviders == null 
                        ? true 
                        : enabledProviders.contains(provider.id);
                        
                    return Column(
                      children: [
                        SwitchListTile(
                          value: isEnabled,
                          activeColor: const Color(0xFF3211d4),
                          onChanged: (val) {
                            var current = ref.read(enabledProvidersProvider);
                            // If null, first initialize it with all providers
                            if (current == null) {
                                current = allProviders.map((p) => p.id).toSet();
                            }
                            
                            if (val) {
                              ref.read(enabledProvidersProvider.notifier).state = {...current, provider.id};
                            } else {
                              ref.read(enabledProvidersProvider.notifier).state = current.difference({provider.id});
                            }
                          },
                          title: Text(
                            provider.name ?? provider.id,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(provider.region ?? provider.address ?? 'Cloud Provider'),
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.menu_book, color: Color(0xFF3211d4)),
                          ),
                        ),
                        if (provider != allProviders.last)
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
