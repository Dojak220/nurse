import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/infra/establishment_repository.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';

class DatabaseEstablishmentRepository extends DatabaseInterface
    implements EstablishmentRepository {
  // ignore: constant_identifier_names
  static const String TABLE = "Establishment";
  final LocalityRepository _localityRepo;

  DatabaseEstablishmentRepository({
    DatabaseManager? dbManager,
    LocalityRepository? localityRepo,
  })  : _localityRepo = localityRepo ?? DatabaseLocalityRepository(),
        super(TABLE, dbManager);

  @override
  Future<int> createEstablishment(Establishment establishment) async {
    final map = establishment.toMap();

    map['locality'] = await _localityRepo
        .getLocalityByIbgeCode(establishment.locality.ibgeCode)
        .then((locality) => locality.id!);

    final int result = await create(map);

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
      return _getEstablishmentFromMap(await getById(id));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Establishment> getEstablishmentByCnes(String cnes) async {
    try {
      return _getEstablishmentFromMap(
        await get(objs: [cnes], where: "cnes = ?").then((maps) => maps.single),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Establishment> _getEstablishmentFromMap(
      Map<String, dynamic> establishmentMap) async {
    final locality = await _getLocality(establishmentMap["locality"] as int);

    final updatedEstablishmentMap = Map.of(establishmentMap);
    updatedEstablishmentMap["locality"] = locality.toMap();

    return Establishment.fromMap(updatedEstablishmentMap);
  }

  Future<Locality> _getLocality(int id) async {
    final locality = await _localityRepo.getLocalityById(id);

    return locality;
  }

  @override
  Future<List<Establishment>> getEstablishments() async {
    try {
      final establishmentMaps = await getAll();
      final localities = await _getLocalities();

      for (final establishmentMap in establishmentMaps) {
        final locality = localities.firstWhere((l) {
          return l.id == establishmentMap["locality"];
        });

        establishmentMap["locality"] = locality.toMap();
      }

      final establishments = establishmentMaps
          .map((establishment) => Establishment.fromMap(establishment))
          .toList();

      return establishments;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Locality>> _getLocalities() async {
    final localities = await _localityRepo.getLocalities();

    return localities;
  }

  @override
  Future<int> updateEstablishment(Establishment establishment) async {
    int updatedRows = await _localityRepo.updateLocality(
      establishment.locality,
    );
    if (updatedRows != 1) return 0;

    updatedRows += await update(establishment.toMap());
    if (updatedRows != 2) return 0;

    return updatedRows;
  }
}
