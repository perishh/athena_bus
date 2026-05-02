import 'package:athena_bus/models/stop.dart';
import 'package:athena_bus/services/database_service.dart';
import 'package:flutter_map/flutter_map.dart';

class StopRepository {
  const StopRepository._();

  static Future<List<Stop>> getStopsInRect(LatLngBounds rect) async {
    final db = await DatabaseService.instance.database;

    final stops = await db.rawQuery(
      "SELECT * FROM stops WHERE lat BETWEEN ? AND ? AND lng BETWEEN ? AND ?",
      [rect.south, rect.north, rect.west, rect.east],
    );

    return stops.map(Stop.fromMap).toList();
  }
}
