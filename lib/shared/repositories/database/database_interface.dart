import "package:nurse/shared/repositories/database/database_manager.dart";
import "package:sqflite_sqlcipher/sqflite.dart";

class DatabaseInterface {
  final DatabaseManager dbManager;
  final String tableName;

  DatabaseInterface(this.tableName, [DatabaseManager? dbManager])
      : dbManager = dbManager ?? DatabaseManager();

  /// TODO: Garantir que não criem-se dois registros com o mesmo id.
  /// Coloquei esse todo aqui, mas possa ser que a implementação seja feita
  /// nas classes que extendem essa. Antes de tentar implementar, é necessário
  /// verificar se o banco de dados já não se responsabiliza por isso.
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
      throw Exception("Id must be greater than 0");
    }

    final int count = await dbManager.db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );

    return count;
  }

  Future<Map<String, dynamic>> getById(int id) async {
    final result = await get(objs: [id], where: "id = ?");
    return result.single;
  }

  Future<List<Map<String, dynamic>>> get({
    List<Object?>? objs,
    String? where,
  }) async {
    try {
      return await dbManager.db.query(
        tableName,
        where: where,
        whereArgs: objs,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final List<Map<String, dynamic>> immutableMapList = await get();

      return List.of(
        immutableMapList.map((map) => Map.from(map)),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<int> update(Map<String, dynamic> entity) async {
    try {
      final int count = await dbManager.db.update(
        tableName,
        entity,
        where: "id = ?",
        whereArgs: [entity["id"]],
      );

      return count;
    } catch (e) {
      rethrow;
    }
  }
}
