import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/establishment_repository.dart';

class DatabaseEstablishmentRepository extends DatabaseInterface
    implements EstablishmentRepository {
  static const String TABLE = "establishment";
  final DatabaseManager dbManager;

  DatabaseEstablishmentRepository(this.dbManager) : super(dbManager, TABLE);

  @override
  Future<int> createEstablishment(Establishment establishment) async {
    final int result = await create(establishment);

    return result;
  }

  @override
  Future<int> deleteEstablishment(int id) async {
    final int count = await delete(id);

    return count;
  }

  @override
  Future<Establishment> getEstablishment(int id) async {
    final Establishment establishment = await get(
      id,
      (Map<String, dynamic> map) => Establishment.fromMap(map),
    );

    return establishment;
  }

  @override
  Future<List<Establishment>> getEstablishments() async {
    final List<Establishment> establishments = await getAll(
      (Map<String, dynamic> map) => Establishment.fromMap(map),
    );

    return establishments;
  }

  @override
  Future<int> updateEstablishment(Establishment establishment) async {
    final int count = await update(establishment);

    return count;
  }
}
