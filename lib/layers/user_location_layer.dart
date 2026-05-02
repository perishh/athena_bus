import 'package:athena_bus/providers/location_manager_provider.dart';
import 'package:athena_bus/providers/map_controller_provider.dart';
import 'package:athena_bus/providers/stops_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserLocationLayer extends HookConsumerWidget {
  const UserLocationLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(mapControllerProvider);
    final point = ref.watch(locationProvider).asData?.value.position;

    final hasFocused = useState(false);
    useEffect(() {
      if (point != null && !hasFocused.value) {
        hasFocused.value = true;
        mapController
            .animateTo(dest: point, zoom: 16.5)
            .then(
              (_) => ref
                  .read(stopsProvider.notifier)
                  .loadStops(mapController.mapController.camera.visibleBounds),
            );
      }
      return null;
    }, [point]);

    return MarkerLayer(
      markers: [
        if (point != null)
          Marker(
            point: point,
            width: 22,
            height: 22,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 53, 124, 238),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
