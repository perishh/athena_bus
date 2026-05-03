import 'package:athena_bus/models/dataset.dart';
import 'package:athena_bus/services/api_service.dart';
import 'package:athena_bus/services/database_service.dart';

// TODO: Add version checking
class DatasetService {
  DatasetService._();

  static Future<bool> downloadDataset(Dataset dataset) async {
    try {
      final db = await DatabaseService.instance.database;

      if (dataset == Dataset.lines) {
        final data = await ApiService.getLines();
        await db.transaction((txn) async {
          var batch = txn.batch();
          for (var line in data) {
            final sql = line.sqlQuery;
            batch.rawInsert(
              "INSERT INTO ${dataset.table}(${sql.$1}) VALUES (${List.filled(sql.$2.length, '?').join(',')})",
              sql.$2,
            );
          }
          await batch.commit(noResult: true);
        });
      } else {
        final data = await ApiService.getGzippedData(dataset.endpoint);
        await db.transaction((txn) async {
          var batch = txn.batch();
          for (var line in data.substring(1, data.length - 1).split("),(")) {
            var formatted = line
                .replaceAll(RegExp("(\"null\"|\"\")"), "NULL")
                .replaceAll("'", r"''")
                .replaceAll(RegExp(r'(?<!\\)"'), "'");
            batch.rawInsert(
              "INSERT INTO ${dataset.table}(${dataset.columns}) VALUES ($formatted)",
            );
          }
          await batch.commit(noResult: true);
        });
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> isDownloaded(Dataset dataset) async {
    final db = await DatabaseService.instance.database;

    final res = await db.query(dataset.table, columns: ['COUNT(1)']);
    return res[0]['COUNT(1)'] as int > 0;
  }
}
