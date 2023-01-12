import "dart:async";

import "package:flutter/services.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:path/path.dart";
import "package:sqflite_sqlcipher/sqflite.dart";

// coverage:ignore-file
class DatabaseManager {
  Database? _db;
  Database get db => _db!;
  bool _isDatabaseInitialized = false;

  static final DatabaseManager _instance = DatabaseManager._internal();

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal();

  Future<void> tryToInit() async {
    if (!_isDatabaseInitialized || _db == null) {
      await _init();
    }
  }

  Future<void> _init() async {
    final String path = join(
      await getDatabasesPath(),
      dotenv.get("DATABASE_NAME"),
    );
    final String password = dotenv.get("DATABASE_PASSWORD");

    _db = await openDatabase(
      path,
      version: 1,
      password: password,
      onCreate: (db, version) => _onCreate(db, version),
    );

    _isDatabaseInitialized = true;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    final Batch batch = db.batch();
    final String script = await rootBundle.loadString("assets/script_v4_0.sql");
    final List<String> scripts = script.split(";");

    for (final script in scripts) {
      if (isValidScript(script)) {
        batch.execute(script.trim());
      }
    }

    await batch.commit();
  }

  bool isValidScript(String script) => script.isNotEmpty && script != " ";
}
