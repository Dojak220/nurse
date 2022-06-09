import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';

class DatabaseLocalityRepository extends DatabaseInterface
    implements LocalityRepository {
  static const String TABLE = "Locality";

  DatabaseLocalityRepository([DatabaseManager? dbManager])
      : super(TABLE, dbManager);

  @override
  Future<int> createLocality(Locality locality) async {
    final int result = await create(locality.toMap());

    return result;
  }

  @override
  Future<int> deleteLocality(int id) async {
    final int count = await delete(id);

    return count;
  }

  @override
  Future<Locality> getLocalityById(int id) async {
    try {
      final localityMap = await getById(id);
      final locality = Locality.fromMap(localityMap);

      return locality;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Locality> getLocalityByIbgeCode(String ibgeCode) async {
    try {
      final localityMap = await get(ibgeCode, where: "ibge_code = ?");
      final locality = Locality.fromMap(localityMap);

      return locality;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Locality>> getLocalities() async {
    try {
      final localityMaps = await getAll();

      final List<Locality> localities = List<Locality>.generate(
        localityMaps.length,
        (index) {
          return Locality.fromMap(localityMaps[index]);
        },
      );

      return localities;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updateLocality(Locality locality) async {
    final int count = await update(locality.toMap());

    return count;
  }
}
