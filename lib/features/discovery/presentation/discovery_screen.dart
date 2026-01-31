import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_der_gedanken/core/models/event.dart';
import 'package:salon_der_gedanken/core/services/event_service.dart';
import 'package:salon_der_gedanken/core/services/location_service.dart';
import 'package:salon_der_gedanken/core/providers/favorites_provider.dart';
import 'package:salon_der_gedanken/core/models/provider_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _sortByProximity = false;
  Position? _currentPosition;
  double _searchRadius = 20.0; // Default max distance
  final ScrollController _scrollController = ScrollController();
  bool _shouldScrollToNow = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final position = await LocationService().getCurrentLocation();
    if(mounted && position != null) {
      setState(() {
        _currentPosition = position;
        // Automatically enable proximity sort if location is found? 
        // User asked for slider to determine distance, implying filtering.
        // We will keep _sortByProximity toggle separate for now or maybe just use distance for filtering.
      });
    }
  }

  Future<void> _toggleProximitySort() async {
    if (_sortByProximity) {
      setState(() => _sortByProximity = false);
      return;
    }

    if (_currentPosition == null) {
         await _initLocation();
    }

    if (_currentPosition != null) {
      setState(() {
        _sortByProximity = true;
      });
    } else {
       if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission required for nearby sort')));
       }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icon/Icon_SalonDerGedanken.png',
              height: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Salon der Gedanken',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.grey),
            onPressed: () {
              ref.refresh(refreshEventsProvider);
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.grey[100]!),
            ),
            child: const Icon(Icons.person, size: 20, color: Colors.grey),
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Date Selector
              SliverToBoxAdapter(
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey[50]!)),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: 14,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final date = DateTime.now().add(Duration(days: index));
                      final isSelected = DateUtils.isSameDay(date, _selectedDate);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = date;
                            _shouldScrollToNow = true; // Reset scroll flag when date changes
                          });
                        },
                        child: _DateChip(date: date, isSelected: isSelected),
                      );
                    },
                  ),
                ),
              ),
              
              // Filter Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    children: [
                      // Distance Slider replaces Search
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Distance',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  '${_searchRadius.round()} km',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3211d4),
                                  ),
                                ),
                              ],
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: const Color(0xFF3211d4),
                                inactiveTrackColor: Colors.grey[300],
                                thumbColor: const Color(0xFF3211d4),
                                overlayColor: const Color(0xFF3211d4).withValues(alpha: 0.1),
                                trackHeight: 4.0,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                              ),
                              child: Slider(
                                value: _searchRadius,
                                min: 1,
                                max: 20,
                                divisions: 19,
                                label: '${_searchRadius.round()} km',
                                onChanged: (value) {
                                  setState(() {
                                    _searchRadius = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Filters
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(icon: Icons.check_circle, label: 'Free only', isActive: true),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _toggleProximitySort,
                              child: _FilterChip(
                                icon: Icons.near_me, 
                                label: 'Nearby', 
                                isActive: _sortByProximity
                              ),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(icon: Icons.tune, label: 'Topics'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Events List Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'UPCOMING TODAY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[400],
                          letterSpacing: 1.2,
                        ),
                      ),
                      // Count moved inside builder to reflect filtered count
                    ],
                  ),
                ),
              ),

              // Event Items
              eventsAsync.when(
                data: (events) {
                  var filteredEvents = events.where((e) => DateUtils.isSameDay(e.startDateTime, _selectedDate)).toList();
                  
                  // Filter by Distance
                  if (_currentPosition != null) {
                    filteredEvents = filteredEvents.where((e) {
                      if (e.latitude == null || e.longitude == null) return false;
                      final distanceInMeters = Geolocator.distanceBetween(
                        _currentPosition!.latitude, _currentPosition!.longitude, 
                        e.latitude!, e.longitude!
                      );
                      return (distanceInMeters / 1000) <= _searchRadius;
                    }).toList();
                  }

                  // Ensure chronological sort (primary sort)
                  filteredEvents.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

                  // Sort by proximity if enabled (secondary sort or override?)
                  // User request implies chronological is strict.
                  // If proximity is enabled, maybe we should sort by proximity primarily?
                  // The user request "Die liste der Events soll chonologisch geordnet sein" is quite specific.
                  // But "Nearby" toggle implies sorting by distance.
                  // Let's keep proximity sort if enabled, otherwise chronological.
                  if (_sortByProximity && _currentPosition != null) {
                    filteredEvents.sort((a, b) {
                      if (a.latitude == null || a.longitude == null) return 1;
                      if (b.latitude == null || b.longitude == null) return -1;
                      
                      final distA = Geolocator.distanceBetween(
                        _currentPosition!.latitude, _currentPosition!.longitude, 
                        a.latitude!, a.longitude!
                      );
                      final distB = Geolocator.distanceBetween(
                        _currentPosition!.latitude, _currentPosition!.longitude, 
                        b.latitude!, b.longitude!
                      );
                      return distA.compareTo(distB);
                    });
                  }

                  // Auto-scroll logic to current time
                  if (_shouldScrollToNow && !_sortByProximity && DateUtils.isSameDay(_selectedDate, DateTime.now())) {
                    final now = DateTime.now();
                    final firstFutureIndex = filteredEvents.indexWhere((e) {
                      final end = e.endDateTime ?? e.startDateTime.add(const Duration(hours: 1)); // assume 1h if null
                      return end.isAfter(now);
                    });

                    if (firstFutureIndex > 0) {
                      // Schedule scroll after build
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                           // Approx item height + margin = ~110
                           // List header height = ~250 (DateSelector 90 + Filter 100ish + Header 40)
                           // We need to account for the Sliver headers above the list.
                           // Actually, simplest is to scroll relative to list start?
                           // CustomScrollView with offsets is tricky.
                           // Let's try a safe estimate.
                           // Header height is roughly 90 + 130 + 40 = ~260.
                           double offset = 260.0 + (firstFutureIndex * 116.0); // 116 approx height
                           
                           _scrollController.animateTo(
                             offset, 
                             duration: const Duration(milliseconds: 500), 
                             curve: Curves.easeOut,
                           );
                        }
                      });
                    }
                    // Disable flag to prevent repeated scrolling
                    // We need to do this carefully inside the build cycle or callback.
                    // Doing it in callback is safer.
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                         if(mounted) setState(() => _shouldScrollToNow = false);
                    });
                  } else {
                     // If not today or sorting by proximity, simplify disable flag
                     if (_shouldScrollToNow) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                             if(mounted) setState(() => _shouldScrollToNow = false);
                        });
                     }
                  }

                  // Show count
                  // (Ideally we'd update the header count but slivers make it tricky to pass data up easily without Riverpod state)
                  
                  if (filteredEvents.isEmpty) {
                     return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            children: [
                              const Text('No events found'),
                              if (_currentPosition == null)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Waiting for location...', 
                                    style: TextStyle(fontSize: 12, color: Colors.grey)
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _EventListItem(
                          event: filteredEvents[index],
                          isPast: filteredEvents[index].endDateTime != null 
                              ? filteredEvents[index].endDateTime!.isBefore(DateTime.now())
                              : filteredEvents[index].startDateTime.add(const Duration(hours: 2)).isBefore(DateTime.now()), // fallback assumption
                        );
                      },
                      childCount: filteredEvents.length,
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (err, stack) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error: $err'),
                  ),
                ),
              ),
              
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
          
          // Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                border: Border(top: BorderSide(color: Colors.grey[100]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavBarItem(icon: Icons.explore, label: 'Explore', isActive: true),
                  _NavBarItem(
                    icon: Icons.favorite_border, 
                    label: 'Liked',
                    onTap: () => context.push('/liked'),
                  ),
                  _NavBarItem(icon: Icons.calendar_today, label: 'Events'),
                  _NavBarItem(
                    icon: Icons.settings, 
                    label: 'Providers',
                    onTap: () => context.push('/settings'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final DateTime date;
  final bool isSelected;

  const _DateChip({required this.date, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF3211d4) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? null : Border.all(color: Colors.grey[100]!),
        boxShadow: isSelected 
          ? [BoxShadow(color: const Color(0xFF3211d4).withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))]
          : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weekdays[date.weekday - 1],
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: isSelected ? Colors.white : Colors.grey[400],
            ),
          ),
          Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _FilterChip({required this.icon, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF3211d4).withValues(alpha: 0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: isActive ? null : Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Icon(
            icon, 
            size: 16, 
            color: isActive ? const Color(0xFF3211d4) : Colors.grey[600]
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive ? const Color(0xFF3211d4) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavBarItem({
    required this.icon, 
    required this.label, 
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF3211d4) : Colors.grey[400];
    return GestureDetector(
      onTap: onTap,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    );
  }
}

class _EventListItem extends ConsumerWidget {
  final Event event;
  final bool isPast;

  const _EventListItem({required this.event, this.isPast = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(event.id);

    final timeFormat = DateFormat('HH:mm');
    final startTime = timeFormat.format(event.startDateTime);
    final endTime = event.endDateTime != null ? ' - ${timeFormat.format(event.endDateTime!)}' : '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // Added vertical margin slightly
      decoration: BoxDecoration(
         color: isPast ? Colors.grey[200] : Colors.white, // In the design the list itself might be white but items are separated
         borderRadius: BorderRadius.circular(12), // Added radius for better look with background color
         border: Border.all(color: Colors.grey[100]!), // changed bottom border to full border
         // box-shadow? maybe
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3211d4).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$startTime$endTime',
                          style: TextStyle(
                            color: isPast ? Colors.grey[500] : const Color(0xFF3211d4),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Consumer(
                        builder: (context, ref, child) {
                          final providersAsync = ref.watch(eventProvidersProvider);
                          return providersAsync.when(
                            data: (providers) {
                              final provider = providers.firstWhere(
                                (p) => p.id == event.providerId, 
                                // Create a dummy provider or handle null if preferable, 
                                // but firstWhere with orElse is safer.
                                orElse: () => ProviderConfig(
                                  id: event.providerId, 
                                  name: event.providerId, // Fallback to ID
                                  enabled: true, 
                                  module: '', 
                                  updateInterval: ''
                                ),
                              );
                              final displayName = provider.name ?? event.providerId;
                              
                              return Flexible(
                                child: Text(
                                  displayName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          );
                        }
                      ),
                      const SizedBox(width: 8),
                      if (event.isFree)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.green[100]!),
                          ),
                          child: Text(
                            'FREE',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isPast ? Colors.grey[500] : const Color(0xFF0f172a), // slate-900
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.locationName ?? event.address ?? 'Unknown Location',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(event.id);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.transparent, // increase touch area
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border, 
                    color: isFavorite ? Colors.red : Colors.grey[300],
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
    );
  }
}
