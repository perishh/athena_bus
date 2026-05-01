import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: FlutterMap(
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
          ],
        ),
      ),
    );
  }
}
