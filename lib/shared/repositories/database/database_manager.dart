import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  DatabaseManager._internal();

  Database? _db;
  Database get db => _db!;
  bool isDatabaseInitialized = false;

  factory DatabaseManager() {
    return _instance;
  }

  Future<void> tryToInit() async {
    if (!isDatabaseInitialized || _db == null) {
      await _init();
    }
  }

  Future<void> _init() async {
    String path = join(await getDatabasesPath(), dotenv.get('DATABASE_NAME'));
    String password = dotenv.get('DATABASE_PASSWORD');

    _db = await openDatabase(
      path,
      version: 1,
      password: password,
      onCreate: (db, version) => _onCreate(db, version),
    );

    isDatabaseInitialized = true;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    final Batch batch = db.batch();
    final String script = await rootBundle.loadString("assets/script_v2_2.sql");
    final List<String> scripts = script.split(";");

    scripts.forEach((script) {
      if (isValidScript(script)) {
        batch.execute(script.trim());
      }
    });

    await batch.commit();
  }

  bool isValidScript(String script) => script.isNotEmpty && script != ' ';
}
