import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseInterface {
  final DatabaseManager dbManager;
  final String tableName;

  DatabaseInterface(this.dbManager, this.tableName);

  Future<int> create(Map<String, dynamic> entity) async {
    final int result = await dbManager.db.insert(
      tableName,
      entity,
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );

    return result;
  }

  Future<int> delete(int id) async {
    if (id <= 0) {
      throw Exception('Id must be greater than 0');
    }

    final int count = await dbManager.db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return count;
  }

  Future<Map<String, dynamic>> get(int id) async {
    List<Map<String, dynamic>> entityMap;

    entityMap = await dbManager.db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    try {
      return entityMap.single;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final List<Map<String, dynamic>> entityMaps =
        await dbManager.db.query(tableName);

    return entityMaps;
  }

  Future<int> update(Map<String, dynamic> entity) async {
    final int count = await dbManager.db.update(
      tableName,
      entity,
      where: 'id = ?',
      whereArgs: [entity['id']],
    );

    return count;
  }
}
