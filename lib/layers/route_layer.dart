import 'package:athena_bus/providers/selected_route_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RouteLayer extends ConsumerWidget {
  const RouteLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedRouteProvider);

    if (selected == null) {
      return const SizedBox.shrink();
    }

    final routeDetails = ref.watch(routeDetailsProvider(selected.$1.id)).value?.details;

    if (routeDetails == null) {
      return const SizedBox.shrink();
    }

    return PolylineLayer(
      polylines: [
        Polyline(
          points: routeDetails.path,
          color: const Color.fromARGB(255, 46, 146, 228),
          strokeWidth: 5,
        ),
      ],
    );
  }
}
