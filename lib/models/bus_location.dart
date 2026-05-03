import 'package:latlong2/latlong.dart';

class BusLocation {
  final String vehicle;
  final String date;
  final LatLng position;
  final String routeCode;

  BusLocation({
    required this.vehicle,
    required this.date,
    required this.position,
    required this.routeCode,
  });

  factory BusLocation.fromJson(Map<String, dynamic> json) {
    return BusLocation(
      vehicle: json["VEH_NO"].toString(),
      date: json["CS_DATE"].toString(),
      position: LatLng(
        double.parse(json["CS_LAT"].toString()),
        double.parse(json["CS_LNG"].toString()),
      ),
      routeCode: json["ROUTE_CODE"].toString(),
    );
  }
}
