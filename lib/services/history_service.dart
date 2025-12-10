import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/alert_event.dart';

class HistoryService {
  static const _dbName = 'alerts.db';
  static const _tableName = 'events';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            processedAt TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  Future<int> insertEvent(AlertEvent event) async {
    final db = await database;
    return db.insert(_tableName, event.toMap());
  }

  Future<List<AlertEvent>> getAllEvents() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      orderBy: 'createdAt DESC',
    );
    return maps.map((m) => AlertEvent.fromMap(m)).toList();
  }
}