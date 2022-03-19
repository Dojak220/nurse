import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseInterface<T extends GenericModel> {
  final DatabaseManager dbManager;
  final String tableName;

  DatabaseInterface(this.dbManager, this.tableName);

  Future<int> create(T entity) async {
    final int result = await dbManager.db.insert(
      tableName,
      entity.toMap(),
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

  Future<T> get<T>(int id, Function fromMapConstructor) async {
    List<Map<String, dynamic>> entityMap;

    try {
      entityMap = await dbManager.db.query(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      final T entity = entityMap.isNotEmpty
          ? fromMapConstructor(entityMap.first)
          : throw Exception('Entity ${T.runtimeType} not found');

      return entity;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<T>> getAll<T>(Function fromMapConstructor) async {
    final List<Map<String, dynamic>> entities =
        await dbManager.db.query(tableName);

    return List<T>.generate(entities.length, (index) {
      return fromMapConstructor(entities[index]);
    });
  }

  Future<int> update(T entity) async {
    final int count = await dbManager.db.update(
      tableName,
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );

    return count;
  }
}
