import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:athena_bus/hooks/use_bottom_sheet_navigation.dart';
import 'package:athena_bus/models/stop.dart';
import 'package:athena_bus/providers/bottom_sheet_navigation_provider.dart';
import 'package:athena_bus/providers/map_controller_provider.dart';
import 'package:athena_bus/providers/selected_route_provider.dart';
import 'package:athena_bus/providers/stops_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

class StopLayer extends HookConsumerWidget {
  const StopLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(mapControllerProvider).mapController;
    final stops = ref.watch(stopsProvider);

    final bottomSheetNavigation = useBottomSheetNavigation(ref);
    final selectedStop = bottomSheetNavigation
        .getCurrentPageAs<ArrivalsPage>()
        ?.stop;

    final selectedRoute = ref.watch(selectedRouteProvider);
    final routeDetails = selectedRoute != null
        ? ref.watch(routeDetailsProvider(selectedRoute.$1.id)).value?.details
        : null;

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

    final stopList = useMemoized(() {
      if (selectedRoute == null) {
        return stops;
      } else {
        final allStops = routeDetails?.stops ?? [];
        return allStops
            .fold<Map<int, Stop>>({}, (acc, stop) {
              acc[stop.id] = stop;
              return acc;
            })
            .values
            .toList();
      }
    }, [selectedRoute, stops, routeDetails]);

    return MarkerLayer(
      markers: stopList.map((stop) {
        final isSelected = selectedStop?.id == stop.id;
        return Marker(
          key: ValueKey('stop-${stop.id}'),
          point: LatLng(stop.lat, stop.lng),
          height: 36,
          width: 36,
          child: GestureDetector(
            onTap: () =>
                bottomSheetNavigation.pushOrReplace(ArrivalsPage(stop)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.withAlpha(240)
                    : Colors.white.withAlpha(240),
                borderRadius: BorderRadius.circular(1000),
                boxShadow: [
                  BoxShadow(
                    blurRadius: isSelected ? 12 : 8,
                    color: isSelected
                        ? Colors.blue.withAlpha(100)
                        : Colors.black26,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  MaterialCommunityIcons.bus_stop,
                  color: isSelected ? Colors.white : Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
