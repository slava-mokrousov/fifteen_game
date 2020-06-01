import 'dart:async';

import 'package:fifteen_game/database/records.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'TestDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Leaderboard ("
          "moves INTEGER"
          ")");
    });
  }

  newRecord(int record) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into Leaderboard (moves)"
        " VALUES (?)",
        [record]);
    return raw;
  }

  Future<List<Record>> getAllRecords() async {
    final db = await database;
    var res = await db.query("Leaderboard", orderBy: "moves ASC");
    List<Record> list = res.isNotEmpty ? res.map((e) => Record.fromMap(e)).toList() : null;
    return list;
  }

  deleteWorst() async {
    final db = await database;
    db.delete("Leaderboard", where: "moves NOT IN ( "
        "SELECT moves FROM Leaderboard "
        "ORDER BY moves ASC "
        "LIMIT 20"
        ")",);
  }
  
  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from Leaderboard");
  }
}
