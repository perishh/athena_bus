import 'package:athena_bus/layers/bus_location_layer.dart';
import 'package:athena_bus/layers/route_layer.dart';
import 'package:athena_bus/layers/stop_layer.dart';
import 'package:athena_bus/layers/user_location_layer.dart';
import 'package:athena_bus/providers/map_controller_provider.dart';
import 'package:athena_bus/screen/main/widgets/dataset_button.dart';
import 'package:athena_bus/screen/main/widgets/location_button.dart';
import 'package:athena_bus/screen/main/widgets/route_top_bar.dart';
import 'package:athena_bus/sheets/main_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with TickerProviderStateMixin {
  late final mapController = AnimatedMapController(vsync: this);
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        mapControllerProvider.overrideWithValue(mapController),
      ],
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapController.mapController,
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
                const RouteLayer(),
                const StopLayer(),
                const BusLocationLayer(),
                const UserLocationLayer(),
              ],
            ),
            const DatasetButton(),
            const LocationButton(),
            const MainBottomSheet(),
            const RouteTopBar(),
          ],
        ),
      ),
    );
  }
}
