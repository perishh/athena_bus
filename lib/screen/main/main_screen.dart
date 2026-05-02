import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/layers/stop_layer.dart';
import 'package:athena_bus/layers/user_location_layer.dart';
import 'package:athena_bus/providers/map_controller_provider.dart';
import 'package:athena_bus/screen/main/widgets/location_button.dart';
import 'package:athena_bus/sheets/arrivals/arrivals_bottom_sheet.dart';
import 'package:athena_bus/sheets/dataset/dataset_bottom_sheet.dart';
import 'package:athena_bus/widgets/blurred_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late final _mapController = AnimatedMapController(vsync: this);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        mapControllerProvider.overrideWithValue(_mapController),
      ],
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController.mapController,
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
                const StopLayer(),
                const UserLocationLayer(),
              ],
            ),
            Positioned(
              right: 16,
              top: 16,
              child: SafeArea(
                child: BlurredContainer(
                  padding: EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(999),
                  child: Icon(MaterialCommunityIcons.database_outline),
                  onTap: () {
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
                child: BlurredContainer(
                  child: Icon(MaterialCommunityIcons.crosshairs_gps),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => const DatasetBottomSheet(),
                    );
                  },
                ),
              ),
            ),
            const LocationButton(),
            const ArrivalsBottomSheet(),
          ],
        ),
      ),
    );
  }
}
