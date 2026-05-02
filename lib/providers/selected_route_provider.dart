import 'package:athena_bus/models/route.dart';
import 'package:athena_bus/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_route_provider.g.dart';

@Riverpod()
Future<RouteDetails> routeDetails(Ref ref, int routeId) async {
  return await ApiService.getRoutePath(routeId);
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
