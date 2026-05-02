import 'package:athena_bus/providers/location_manager_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserLocationLayer extends HookConsumerWidget {
  const UserLocationLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final point = ref.watch(locationProvider).asData?.value.position;

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
