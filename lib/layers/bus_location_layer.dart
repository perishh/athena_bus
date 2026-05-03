import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/providers/selected_route_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BusLocationLayer extends ConsumerWidget {
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

    return MarkerLayer(
      markers: busLocations.map((bus) {
        return Marker(
          key: ValueKey('veh-${bus.vehicle}'),
          point: bus.position,
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
