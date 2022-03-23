import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/establishment_repository.dart';

class DatabaseEstablishmentRepository extends DatabaseInterface
    implements EstablishmentRepository {
  static const String TABLE = "establishment";
  final DatabaseManager dbManager;

  DatabaseEstablishmentRepository(this.dbManager) : super(dbManager, TABLE);

  @override
  Future<int> createEstablishment(Establishment establishment) async {
    final int result = await create(establishment.toMap());

    return result;
  }

  @override
  Future<int> deleteEstablishment(int id) async {
    final int count = await delete(id);

    return count;
  }

  @override
  Future<Establishment> getEstablishmentById(int id) async {
    try {
      final establishmentMap = await get(id);

      final locality = await _getLocality(establishmentMap["locality"]);

      establishmentMap["locality"] = locality;

      final establishment = Establishment.fromMap(establishmentMap);

      return establishment;
    } catch (e) {
      rethrow;
    }
  }

  Future<Locality> _getLocality(int id) async {
    final dbRepo = DatabaseLocalityRepository(dbManager);
    final locality = await dbRepo.getLocalityById(id);

    return locality;
  }

  @override
  Future<List<Establishment>> getEstablishments() async {
    final establishmentMaps = await getAll();
    final localities = await _getLocalities();

    establishmentMaps.forEach((e) {
      final locality = localities.firstWhere((l) {
        return l.id == e["locality"];
      });

      e["locality"] = locality;
    });

    final establishments = establishmentMaps
        .map((establishment) => Establishment.fromMap(establishment))
        .toList();

    return establishments;
  }

  Future<List<Locality>> _getLocalities() async {
    final dbRepo = DatabaseLocalityRepository(dbManager);
    final localities = await dbRepo.getLocalities();

    return localities;
  }

  @override
  Future<int> updateEstablishment(Establishment establishment) async {
    final int count = await update(establishment.toMap());

    return count;
  }
}
