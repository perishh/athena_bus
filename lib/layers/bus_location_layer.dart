import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/models/bus_location.dart';
import 'package:athena_bus/providers/selected_route_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

class BusLocationLayer extends HookConsumerWidget {
  const BusLocationLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedRouteProvider);

    if (selected == null) {
      return const SizedBox.shrink();
    }

    final routeState = ref.watch(routeDetailsProvider(selected.$1.id));

    final busLocations = routeState.value?.busLocations;

    if (busLocations == null || busLocations.isEmpty) {
      return const SizedBox.shrink();
    }

    return _AnimatedBusMarkers(busLocations: busLocations);
  }
}

class _AnimatedBusMarkers extends StatefulWidget {
  final List<BusLocation> busLocations;

  const _AnimatedBusMarkers({required this.busLocations});

  @override
  State<_AnimatedBusMarkers> createState() => _AnimatedBusMarkersState();
}

class _AnimatedBusMarkersState extends State<_AnimatedBusMarkers>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Map<String, LatLng> _prevPositions;
  late Map<String, LatLng> _targetPositions;
  late Map<String, LatLng> _displayPositions;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _prevPositions = {};
    _targetPositions = {};
    _displayPositions = {};

    // Seed initial positions
    for (final bus in widget.busLocations) {
      _targetPositions[bus.vehicle] = bus.position;
      _displayPositions[bus.vehicle] = bus.position;
    }

    _controller.addListener(_onTick);
  }

  @override
  void didUpdateWidget(covariant _AnimatedBusMarkers oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Build the new target map
    final newTargets = <String, LatLng>{};
    for (final bus in widget.busLocations) {
      newTargets[bus.vehicle] = bus.position;
    }

    // For each new bus location, if we have a previous position that differs,
    // set up an animation from old to new.
    bool needsAnimation = false;
    final updatedPrev = <String, LatLng>{};

    for (final bus in widget.busLocations) {
      final vehicle = bus.vehicle;
      final oldPos = _targetPositions[vehicle];
      final newPos = bus.position;

      if (oldPos != null && oldPos != newPos) {
        // Store the previous (old) position as the starting point
        updatedPrev[vehicle] = oldPos;
        needsAnimation = true;
      } else if (oldPos != null) {
        updatedPrev[vehicle] = oldPos;
      } else {
        // Brand new vehicle: no animation needed, snap to position
        updatedPrev[vehicle] = newPos;
        _displayPositions[vehicle] = newPos;
      }
    }

    if (needsAnimation) {
      _prevPositions = updatedPrev;
      _targetPositions = newTargets;
      _controller.reset();
      _controller.forward();
    } else {
      // No movement: just update targets and display to match
      _targetPositions = newTargets;
      _displayPositions = Map.from(_targetPositions);
    }
  }

  void _onTick() {
    final t = _controller.value;
    final curved = Curves.easeInOutCubic.transform(t);

    for (final entry in _prevPositions.entries) {
      final vehicle = entry.key;
      final from = entry.value;
      final to = _targetPositions[vehicle];
      if (to != null) {
        _displayPositions[vehicle] = LatLng(
          _lerp(from.latitude, to.latitude, curved),
          _lerp(from.longitude, to.longitude, curved),
        );
      }
    }
    setState(() {});
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  void dispose() {
    _controller.removeListener(_onTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: widget.busLocations.map((bus) {
        final pos = _displayPositions[bus.vehicle] ?? bus.position;
        return Marker(
          key: ValueKey('veh-${bus.vehicle}'),
          point: pos,
          width: 32,
          height: 32,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber[700],
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                MaterialCommunityIcons.bus,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
