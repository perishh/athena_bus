import 'package:athena_bus/models/dataset.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _init();
    return _database!;
  }

  Future<Database> _init() async {
    var dbPath = await getDatabasesPath();
    return await openDatabase(
      path.join(dbPath, 'data.db'),
      version: 1,
      onCreate: _create,
    );
  }

  Future _create(Database db, int version) async {
    await db.execute('''
CREATE TABLE `${Dataset.stops.table}` (
  `id` INTEGER PRIMARY KEY NOT NULL,
  `code` VARCHAR(10) NOT NULL,
  `desc` VARCHAR(64) NOT NULL,
  `descEn` VARCHAR(64) NULL DEFAULT NULL,
  `street` VARCHAR(64) NULL DEFAULT NULL,
  `streetEn` VARCHAR(64) NULL DEFAULT NULL,
  `heading` INTEGER NOT NULL DEFAULT 0,
  `lng` DECIMAL NOT NULL,
  `lat` DECIMAL NOT NULL,
  `type` INTEGER NOT NULL,
  `amea` INTEGER NOT NULL,
  `terminal` VARCHAR(400) NULL DEFAULT NULL,
  `terminalEn` VARCHAR(400) NULL DEFAULT NULL
)''');
    await db.execute('''
CREATE INDEX idx_lat_lng ON ${Dataset.stops.table}(lat, lng)''');

    await db.execute('''
CREATE TABLE ${Dataset.routes.table}(
  id INTEGER PRIMARY KEY NOT NULL,
  lineId INTEGER NOT NULL,
  desc VARCHAR(256) NOT NULL,
  descEn VARCHAR(256) NOT NULL,
  type INTEGER NOT NULL,
  length DECIMAL NOT NULL
)''');

    await db.execute('''
CREATE TABLE ${Dataset.lines.table}(
  id INTEGER PRIMARY KEY NOT NULL,
  code VARCHAR(10) NOT NULL,
  desc VARCHAR(256) NOT NULL,
  descEn VARCHAR(256) NOT NULL,
  route1_1 INTEGER NOT NULL,
  route1_2 INTEGER NOT NULL,
  route2_1 INTEGER NOT NULL,
  route2_2 INTEGER NOT NULL,
  route3_1 INTEGER NOT NULL,
  route3_2 INTEGER NOT NULL,
  route4_1 INTEGER NOT NULL,
  route4_2 INTEGER NOT NULL,
  route5_1 INTEGER NOT NULL,
  route5_2 INTEGER NOT NULL,
  route6_1 INTEGER NOT NULL,
  route6_2 INTEGER NOT NULL,
  route7_1 INTEGER NOT NULL,
  route7_2 INTEGER NOT NULL
)''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
