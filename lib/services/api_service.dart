import 'dart:convert';
import 'dart:io';
import 'package:athena_bus/models/arrival.dart';
import 'package:athena_bus/models/bus_location.dart';
import 'package:athena_bus/models/line.dart';
import 'package:athena_bus/models/route.dart';
import 'package:athena_bus/models/schedule.dart';
import 'package:http/http.dart' as http;

final class ApiService {
  ApiService._();

  static Future<String> getGzippedData(String dataset) async {
    final uri = Uri.parse("https://telematics.oasa.gr/api/?act=$dataset");
    final res = await http.get(uri).timeout(const Duration(seconds: 5));
    return utf8.decode(GZipCodec().decode(res.bodyBytes));
  }

  static Future<List<Line>> getLines() async {
    final uri = Uri.parse(
      "https://telematics.oasa.gr/api/?act=webGetLinesWithMLInfo",
    );
    final res = await http.get(uri).timeout(const Duration(seconds: 5));
    final List<dynamic> decoded = jsonDecode(res.body);
    return decoded.map((x) => Line.fromJson(x)).toList();
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
    final List<dynamic> decoded = jsonDecode(
      res.body,
    ); // TODO: Detected null response
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

  static Future<List<ScheduleDay>> getScheduleDays(int lineId) async {
    final uri = Uri.parse(
      "https://telematics.oasa.gr/api/?lang=el&act=getScheduleDaysMasterline&p1=$lineId",
    );
    final res = await http.get(uri);
    final List<dynamic> decoded = jsonDecode(res.body);

    return decoded.map((sched) => ScheduleDay.fromJson(sched)).toList();
  }

  static Future<Schedule> getSchedule(
    int masterLineId,
    int lineId,
    String scheduleCode,
  ) async {
    final uri = Uri.parse(
      "https://telematics.oasa.gr/api/?act=getSchedLines&p1=$masterLineId&p2=$scheduleCode&p3=$lineId",
    );
    final res = await http.get(uri);
    return Schedule.fromJson(jsonDecode(res.body));
  }

  static Future<Schedule> getDailySchedule(int lineId) async {
    final uri = Uri.parse(
      "https://telematics.oasa.gr/api/?act=getDailySchedule&line_code=$lineId",
    );
    final res = await http.get(uri);
    return Schedule.fromJson(jsonDecode(res.body));
  }
}
