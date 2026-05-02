class Arrival {
  final String veh;
  final String time;

  Arrival({required this.veh, required this.time});

  factory Arrival.fromJson(Map<String, dynamic> json) =>
      Arrival(veh: json['veh'].toString(), time: json['time'].toString());
}

class ArrivalRoute {
  final String route;
  final String? next;
  final List<Arrival> arrivals;

  ArrivalRoute({
    required this.route,
    required this.next,
    required this.arrivals,
  });

  factory ArrivalRoute.fromJson(Map<String, dynamic> json) => ArrivalRoute(
    route: json['route'].toString(),
    next: json['next'] as String?,
    arrivals: (json['arrivals'] as List<dynamic>)
        .map((e) => Arrival.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class ArrivalsResponse {
  final List<ArrivalRoute> routes;

  ArrivalsResponse({required this.routes});

  factory ArrivalsResponse.fromJson(Map<String, dynamic> json) =>
      ArrivalsResponse(
        routes: (json['routes'] as List<dynamic>)
            .map((e) => ArrivalRoute.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
