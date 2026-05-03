import 'package:athena_bus/models/dataset.dart';
import 'package:athena_bus/models/line.dart';
import 'package:athena_bus/services/database_service.dart';

class LineRepository {
  const LineRepository._();

  static Future<Line?> getLineById(int id) async {
    final db = await DatabaseService.instance.database;
    final maps = await db.query(
      Dataset.lines.table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Line.fromMap(maps.first);
  }
}
