import 'package:nurse/app/models/infra/establishment_model.dart';
import 'package:nurse/app/repositories/establishment_repository.dart';
import 'package:nurse/app/repositories/repository_interface.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseEstablishmentRepository extends RepositoryInterface
    implements EstablishmentRepository {
  static const String TABLE = "establishment";
  final Database db;

  DatabaseEstablishmentRepository(this.db) : super(db, TABLE);

  @override
  Future<int> createEstablishment(Establishment establishment) async {
    final int result = await create(establishment);

    return result;
  }

  @override
  Future<int> deleteEstablishment(int id) async {
    final int result = await delete(id);

    return result;
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
    final int result = await update(establishment);

    return result;
  }
}
