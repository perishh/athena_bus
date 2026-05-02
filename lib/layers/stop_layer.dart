import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/providers/stops_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

class StopLayer extends HookConsumerWidget {
  final MapController mapController;
  const StopLayer({super.key, required this.mapController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stops = ref.watch(stopsProvider);

    useEffect(() {
      final subscription = mapController.mapEventStream.listen((event) {
        if (event is MapEventMoveEnd ||
            event is MapEventRotateEnd ||
            event is MapEventDoubleTapZoomEnd ||
            event is MapEventFlingAnimationEnd ||
            event is MapEventDoubleTapZoomEnd ||
            event is MapEventFlingAnimationNotStarted) {
          final provider = ref.read(stopsProvider.notifier);
          if (mapController.camera.zoom < 15) {
            provider.clear();
            return;
          }
          provider.loadStops(mapController.camera.visibleBounds);
        }
      });
      return subscription.cancel;
    }, []);

    return MarkerLayer(
      markers: stops.map((stop) {
        return Marker(
          point: LatLng(stop.lat, stop.lng),
          height: 36,
          width: 36,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(240),
                borderRadius: BorderRadius.circular(1000),
                boxShadow: [
                  BoxShadow(blurRadius: 8, color: Colors.black26),
                ],
              ),
              child: Icon(
                MaterialCommunityIcons.bus_stop,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
