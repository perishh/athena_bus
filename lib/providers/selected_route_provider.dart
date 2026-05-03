import 'dart:async';

import 'package:athena_bus/models/bus_location.dart';
import 'package:athena_bus/models/route.dart';
import 'package:athena_bus/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_route_provider.g.dart';

@Riverpod(keepAlive: true)
class RouteDetailsNotifier extends _$RouteDetailsNotifier {
  Timer? _timer;

  @override
  Future<({RouteDetails details, List<BusLocation> busLocations})> build(
    int routeId,
  ) async {
    final details = await ApiService.getRoutePath(routeId);

    ref.onDispose(() {
      _timer?.cancel();
    });

    ref.onCancel(() {
      _timer?.cancel();
    });

    ref.onResume(() {
      Future.microtask(() async {
        await _updateBusLocations(routeId);
        _startPolling(routeId);
      });
    });

    _updateBusLocations(routeId);
    _startPolling(routeId);

    return (details: details, busLocations: <BusLocation>[]);
  }

  Future<void> _updateBusLocations(int routeId) async {
    try {
      final busLocations = await ApiService.getBusLocations(routeId);
      final current = state.value;
      if (current != null) {
        state = AsyncValue.data(
          (details: current.details, busLocations: busLocations),
        );
      }
    } catch (_) {}
  }

  void _startPolling(int routeId) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) async {
      await _updateBusLocations(routeId);
    });
  }
}

@Riverpod(keepAlive: true)
class SelectedRoute extends _$SelectedRoute {
  @override
  (Route, String)? build() {
    return null;
  }

  void select(Route route, String lineId) {
    state = (route, lineId);
  }

  void deselect() {
    state = null;
  }
}
