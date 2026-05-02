import 'package:athena_bus/models/stop.dart';
import 'package:athena_bus/repositories/stop_repository.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stops_provider.g.dart';

@Riverpod(keepAlive: true)
class Stops extends _$Stops {
  @override
  List<Stop> build() {
    return [];
  }

  Future loadStops(LatLngBounds bounds) async {
    final stops = await StopRepository.getStopsInRect(bounds);
    state = stops;
  }

  void clear() {
    state = [];
  }
}

@Riverpod(keepAlive: true)
class SelectedStop extends _$SelectedStop {
  @override
  Stop? build() {
    return null;
  }

  void select(Stop stop) {
    state = stop;
  }

  void deselect() {
    state = null;
  }
}
