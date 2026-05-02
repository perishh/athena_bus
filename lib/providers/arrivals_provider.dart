import 'dart:async';

import 'package:athena_bus/models/arrival.dart';
import 'package:athena_bus/models/route.dart';
import 'package:athena_bus/repositories/stop_repository.dart';
import 'package:athena_bus/services/api_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'arrivals_provider.g.dart';
part 'arrivals_provider.freezed.dart';

@freezed
abstract class ArrivalsState with _$ArrivalsState {
  const factory ArrivalsState({
    required Set<String> lines,
    required List<(Route, String)> routes,
    required List<ArrivalRoute> arrivals,
    required DateTime lastFetched,
    required bool loading,
    required bool error,
  }) = _ArrivalsState;
}

@Riverpod(keepAlive: true)
class Arrivals extends _$Arrivals {
  Timer? _timer;

  @override
  Future<ArrivalsState> build(int stopId) async {
    final routes = await ApiService.getStopRoutes(stopId);

    ref.onDispose(() {
      _timer?.cancel();
    });

    ref.onCancel(() {
      _timer?.cancel();
    });

    ref.onResume(() {
      Future.microtask(() async {
        await _update();
        _startPolling();
      });
    });

    final state = ArrivalsState(
      lines: routes.map((r) => r.$2).toSet(),
      routes: routes,
      arrivals: [],
      lastFetched: DateTime.now(),
      loading: true,
      error: false,
    );

    _update();
    _startPolling();

    return state;
  }

  Future _update() async {
    if (state.value != null) {
      state = AsyncValue.data(
        state.value!.copyWith(loading: true, error: false),
      );
    }
    try {
      final updatedRoutes = await StopRepository.getArrivals(stopId);

      final sortedRoutes = updatedRoutes.toList()
        ..sort((a, b) => a.sortKey.compareTo(b.sortKey));

      state = AsyncValue.data(
        state.value!.copyWith(
          arrivals: sortedRoutes,
          lastFetched: DateTime.now(),
          loading: false,
          error: false,
        ),
      );
    } catch (_) {
      state = AsyncValue.data(
        state.value!.copyWith(
          loading: false,
          error: true,
        ),
      );
    }
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _update();
    });
  }
}

extension Sort on ArrivalRoute {
  int get sortKey {
    final firstTime = int.tryParse(arrivals.firstOrNull?.time ?? '');
    if (firstTime != null) return firstTime;
    if (next != null) {
      final parts = next!.split(':');
      if (parts.length == 2) {
        final h = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        if (h != null && m != null) {
          return 999 + (h * 60 + m); // To sort after timed arrivals
        }
      }
    }
    return 999999;
  }
}
