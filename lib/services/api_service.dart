import 'dart:convert';
import 'dart:io';
import 'package:athena_bus/models/arrival.dart';
import 'package:athena_bus/models/bus_location.dart';
import 'package:athena_bus/models/route.dart';
import 'package:http/http.dart' as http;

final class ApiService {
  ApiService._();

  static Future<String> getGzippedData(String dataset) async {
    final uri = Uri.parse("https://telematics.oasa.gr/api/?act=$dataset");
    final res = await http.get(uri).timeout(const Duration(seconds: 5));
    return utf8.decode(GZipCodec().decode(res.bodyBytes));
  }

  static Future<ArrivalsResponse> getArrivals(int stopId) async {
    final uri = Uri.parse(
      "https://telematics.oasa.gr/api/?lang=el&act=getStopArrivalsAlt&p1=$stopId",
    );
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    return ArrivalsResponse.fromJson(jsonDecode(res.body));
  }

  static Future<List<(Route, String)>> getStopRoutes(int stopId) async {
    final uri = Uri.parse(
      "https://telematics.oasa.gr/api/?act=webRoutesForStop&p1=$stopId",
    );
    final res = await http.get(uri);
    final List<dynamic> decoded = jsonDecode(res.body);
    return decoded
        .map((x) => (Route.fromJson(x), x['LineID'] as String))
        .toList();
  }

  static Future<RouteDetails> getRoutePath(int routeId) async {
    final uri = Uri.parse(
      "https://telematics.oasa.gr/api/?act=webGetRoutesDetailsAndStops&p1=$routeId",
    );
    final res = await http.get(uri);

    return RouteDetails.fromJson(jsonDecode(res.body));
  }

  static Future<List<BusLocation>> getBusLocations(int routeId) async {
    final uri = Uri.parse(
      "https://telematics.oasa.gr/api/?lang=el&act=getBusLocation&p1=$routeId",
    );
    final res = await http.get(uri);
    final List<dynamic> decoded = jsonDecode(res.body);

    return decoded.map((point) => BusLocation.fromJson(point)).toList();
  }
}
