import 'package:nurse/app/models/generic_model.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class RepositoryInterface<T extends GenericModel> {
  final Database db;
  final String tableName;

  RepositoryInterface(this.db, this.tableName);

  Future<int> create(T entity) async {
    final int result = await db.insert(
      tableName,
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );

    return result;
  }

  Future<int> delete(int id) async {
    final int result = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  Future<T> get<T>(int id, Function fromMapConstructor) async {
    List<Map<String, dynamic>> entityMap;

    try {
      entityMap = await db.query(
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
    final List<Map<String, dynamic>> entities = await db.query(tableName);

    return List<T>.generate(entities.length, (index) {
      return fromMapConstructor(entities[index]);
    });
  }

  Future<int> update(T entity) async {
    final int result = await db.update(
      tableName,
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );

    return result;
  }
}
