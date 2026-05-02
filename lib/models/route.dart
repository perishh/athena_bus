import 'package:athena_bus/models/stop.dart';
import 'package:latlong2/latlong.dart';

class Route {
  final int id;
  final int lineId;
  final String desc;
  final String descEn;
  final int type;
  final double length;

  Route({
    required this.id,
    required this.lineId,
    required this.desc,
    required this.descEn,
    required this.type,
    required this.length,
  });

  factory Route.fromMap(Map<String, Object?> map) {
    return Route(
      id: map['id'] as int,
      lineId: map['lineId'] as int,
      desc: map['desc'] as String,
      descEn: map['descEn'] as String,
      type: map['type'] as int,
      length: double.parse(map['length'].toString()),
    );
  }

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    id: json['RouteCode'] as int,
    lineId: json['LineCode'] as int,
    desc: json['RouteDescr'] as String,
    descEn: json['RouteDescrEng'] as String,
    type: json['RouteType'] as int,
    length: (json['RouteDistance'] as num).toDouble(),
  );
}

class RouteDetails {
  final List<LatLng> path;
  final List<Stop> stops;

  RouteDetails({required this.path, required this.stops});

  factory RouteDetails.fromJson(Map<String, dynamic> json) {
    return RouteDetails(
      path: (json['details'] as List<dynamic>)
          .map(
            (x) => LatLng(
              double.parse(x["routed_y"].toString()),
              double.parse(x["routed_x"].toString()),
            ),
          )
          .toList(),
      stops: (json['stops'] as List<dynamic>)
          .map((x) => Stop.fromJson(x))
          .toList(),
    );
  }
}
