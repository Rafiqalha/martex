import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/measurement.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tumbuhsehat_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE measurements (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      age INTEGER NOT NULL,
      weight REAL NOT NULL,
      height REAL NOT NULL,
      gender TEXT NOT NULL,
      lat REAL NOT NULL,
      lng REAL NOT NULL,
      z_score REAL NOT NULL,
      is_synced INTEGER NOT NULL
    )
    ''');
  }

  Future<int> insertMeasurement(Measurement measurement) async {
    final db = await instance.database;
    return await db.insert('measurements', measurement.toMap());
  }

  Future<List<Measurement>> getAllMeasurements() async {
    final db = await instance.database;
    final maps = await db.query('measurements', orderBy: 'id DESC');
    return maps.map((map) => Measurement.fromMap(map)).toList();
  }

  Future<List<Measurement>> getUnsyncedMeasurements() async {
    final db = await instance.database;
    final maps = await db.query(
      'measurements',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    return maps.map((map) => Measurement.fromMap(map)).toList();
  }

  Future<int> markAsSynced(int id) async {
    final db = await instance.database;
    return await db.update(
      'measurements', 
      {'is_synced': 1}, 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }
}