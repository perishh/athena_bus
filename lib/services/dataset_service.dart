import 'package:athena_bus/services/api_service.dart';
import 'package:athena_bus/services/database_service.dart';

// TODO: Add version checking
class DatasetService {
  DatasetService._();

  static final Map<String, (String, String)> datasetTables = {
    "stops": (
      "getStopsW",
      "id, code, desc, descEn, street, streetEn, heading, lng, lat, type, amea, terminal, terminalEn",
    ),
  };

  static Future<bool> downloadDataset(String dataset) async {
    try {
      final endpoint = datasetTables[dataset]!.$1;
      final cols = datasetTables[dataset]!.$2;
      final db = await DatabaseService.instance.database;

      final data = await ApiService.getGzippedData(endpoint);
      await db.transaction((txn) async {
        var batch = txn.batch();
        for (var line in data.substring(1, data.length - 1).split("),(")) {
          var formatted = line
              .replaceAll(RegExp("(\"null\"|\"\")"), "NULL")
              .replaceAll("'", r"''")
              .replaceAll(RegExp(r'(?<!\\)"'), "'");
          batch.rawInsert("INSERT INTO $dataset($cols) VALUES ($formatted)");
        }
        await batch.commit(noResult: true);
      });
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> isDownloaded(String dataset) async {
    final db = await DatabaseService.instance.database;

    final res = await db.query(dataset, columns: ['COUNT(1)']);
    return res[0]['COUNT(1)'] as int > 0;
  }
}
