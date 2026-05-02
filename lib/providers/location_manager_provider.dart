import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_manager_provider.g.dart';
part 'location_manager_provider.freezed.dart';

@freezed
abstract class LocationManagerState with _$LocationManagerState {
  const factory LocationManagerState({
    required bool enabled,
    required bool permitted,
    required bool live,
    required LatLng? position,
  }) = _LocationManagerState;
}

@Riverpod(keepAlive: true)
class Location extends _$Location {
  StreamSubscription<Position>? _subscription;

  @override
  Future<LocationManagerState> build() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationManagerState(
        enabled: false,
        permitted: false,
        live: false,
        position: null,
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationManagerState(
          enabled: true,
          permitted: false,
          live: false,
          position: null,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationManagerState(
        enabled: true,
        permitted: false,
        live: false,
        position: null,
      );
    }

    final position = await Geolocator.getLastKnownPosition();

    ref.onDispose(() {
      _subscription?.cancel();
      _subscription = null;
    });

    _subscription =
        Geolocator.getPositionStream(
          locationSettings: AndroidSettings(
            accuracy: LocationAccuracy.high,
            intervalDuration: const Duration(seconds: 5),
            distanceFilter: 3,
          ),
        ).listen((pos) {
          state = AsyncValue.data(
            LocationManagerState(
              enabled: true,
              permitted: true,
              live: true,
              position: LatLng(pos.latitude, pos.longitude),
            ),
          );
        });

    return LocationManagerState(
      enabled: true,
      permitted: true,
      live: position != null,
      position: position != null
          ? LatLng(position.latitude, position.longitude)
          : null,
    );
  }
}
