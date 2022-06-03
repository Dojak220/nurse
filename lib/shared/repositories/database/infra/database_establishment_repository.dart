import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/infra/establishment_repository.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';

class DatabaseEstablishmentRepository extends DatabaseInterface
    implements EstablishmentRepository {
  static const String TABLE = "Establishment";
  final LocalityRepository? _localityRepo;

  DatabaseEstablishmentRepository({
    DatabaseManager? dbManager,
    LocalityRepository? localityRepo,
  })  : _localityRepo = localityRepo ?? DatabaseLocalityRepository(),
        super(TABLE, dbManager);

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

      establishmentMap["locality"] = locality.toMap();

      final establishment = Establishment.fromMap(establishmentMap);

      return establishment;
    } catch (e) {
      rethrow;
    }
  }

  Future<Locality> _getLocality(int id) async {
    final locality = await _localityRepo!.getLocalityById(id);

    return locality;
  }

  @override
  Future<List<Establishment>> getEstablishments() async {
    try {
      final establishmentMaps = await getAll();
      final localities = await _getLocalities();

      establishmentMaps.forEach((e) {
        final locality = localities.firstWhere((l) {
          return l.id == e["locality"];
        });

        e["locality"] = locality.toMap();
      });

      final establishments = establishmentMaps
          .map((establishment) => Establishment.fromMap(establishment))
          .toList();

      return establishments;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Locality>> _getLocalities() async {
    final localities = await _localityRepo!.getLocalities();

    return localities;
  }

  @override
  Future<int> updateEstablishment(Establishment establishment) async {
    final int count = await update(establishment.toMap());

    return count;
  }
}
