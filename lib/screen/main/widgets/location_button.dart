import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/providers/location_manager_provider.dart';
import 'package:athena_bus/providers/map_controller_provider.dart';
import 'package:athena_bus/providers/stops_provider.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocationButton extends HookConsumerWidget {
  const LocationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(mapControllerProvider);
    return Positioned(
      right: 16,
      bottom: 16,
      child: SafeArea(
        child: BlurredContainer(
          padding: EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(999),
          child: Icon(MaterialCommunityIcons.crosshairs_gps),
          onTap: () async {
            final position = ref.read(locationProvider).asData?.value.position;

            if (position == null) return;

            await mapController.animateTo(dest: position, zoom: 17);
            ref
                .read(stopsProvider.notifier)
                .loadStops(mapController.mapController.camera.visibleBounds);
          },
        ),
      ),
    );
  }
}
