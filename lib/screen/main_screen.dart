import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/hooks/use_stop_info_bottom_sheet.dart';
import 'package:athena_bus/layers/stop_layer.dart';
import 'package:athena_bus/layers/user_location_layer.dart';
import 'package:athena_bus/providers/backdrop_key_provider.dart';
import 'package:athena_bus/providers/location_manager_provider.dart';
import 'package:athena_bus/providers/stops_provider.dart';
import 'package:athena_bus/sheets/dataset_bottom_sheet.dart';
import 'package:athena_bus/widgets/blur_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final backdropKey = ref.watch(backdropKeyProvider);
    final mapController = useMemoized(() => MapController());

    useStopInfoBottomSheet(ref, scaffoldKey);

    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              maxZoom: 20,
              initialCenter: LatLng(37.971996112, 23.7341637),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: "AthenaBus/1.0",
                maxNativeZoom: 20,
              ),
              StopLayer(mapController: mapController),
              UserLocationLayer(),
            ],
          ),
          Positioned(
            right: 16,
            top: 16,
            child: SafeArea(
              child: BlurIconButton(
                backdropKey: backdropKey,
                elevation: 4,
                icon: MaterialCommunityIcons.database_outline,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const DatasetBottomSheet(),
                  );
                },
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: SafeArea(
              child: BlurIconButton(
                backdropKey: backdropKey,
                elevation: 4,
                icon: MaterialCommunityIcons.crosshairs_gps,
                onPressed: () {
                  final position = ref
                      .read(locationProvider)
                      .asData
                      ?.value
                      .position;

                  if (position == null) return;

                  mapController.move(position, 16.5);
                  ref
                      .read(stopsProvider.notifier)
                      .loadStops(mapController.camera.visibleBounds);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
