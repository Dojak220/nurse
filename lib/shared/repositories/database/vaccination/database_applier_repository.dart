import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_person_repository.dart';
import 'package:nurse/shared/repositories/infra/establishment_repository.dart';
import 'package:nurse/shared/repositories/patient/person_repository.dart';
import 'package:nurse/shared/repositories/vaccination/applier_repository.dart';

class DatabaseApplierRepository extends DatabaseInterface
    implements ApplierRepository {
  // ignore: constant_identifier_names
  static const String TABLE = "Applier";
  final EstablishmentRepository _establishmentRepo;
  final PersonRepository _personRepo;

  DatabaseApplierRepository({
    DatabaseManager? dbManager,
    EstablishmentRepository? establishmentRepo,
    PersonRepository? personRepo,
  })  : _establishmentRepo =
            establishmentRepo ?? DatabaseEstablishmentRepository(),
        _personRepo = personRepo ?? DatabasePersonRepository(),
        super(TABLE, dbManager);

  @override
  Future<int> createApplier(Applier applier) async {
    final map = applier.toMap();

    map['person'] = await _personRepo.createPerson(applier.person);
    map['establishment'] = await _establishmentRepo
        .getEstablishmentByCnes(applier.establishment.cnes)
        .then((establishment) => establishment.id!);

    final int result = await create(map);

    return result;
  }

  @override
  Future<int> deleteApplier(int id) async {
    final int deletedCount = await delete(id);

    return deletedCount;
  }

  @override
  Future<Applier> getApplierById(int id) async {
    try {
      return _getApplierFromMap(await getById(id));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Applier> getApplierByCns(String cns) async {
    try {
      return _getApplierFromMap(
        await get(objs: [cns], where: "cns = ?").then(
          (appliers) => appliers.first,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Applier> _getApplierFromMap(Map<String, dynamic> applierMap) async {
    final person = await _getPerson(applierMap["person"] as int);
    final establishment =
        await _getEstablishment(applierMap["establishment"] as int);

    final updatedApplierMap = Map.of(applierMap);
    updatedApplierMap["person"] = person.toMap();
    updatedApplierMap["person"]["locality"] = person.locality?.toMap();

    updatedApplierMap["establishment"] = establishment.toMap();
    updatedApplierMap["establishment"]["locality"] =
        establishment.locality.toMap();

    return Applier.fromMap(updatedApplierMap);
  }

  Future<Establishment> _getEstablishment(int id) async {
    final establishment = await _establishmentRepo.getEstablishmentById(id);

    return establishment;
  }

  Future<Person> _getPerson(int id) async {
    final person = await _personRepo.getPersonById(id);

    return person;
  }

  @override
  Future<List<Applier>> getAppliers() async {
    try {
      final applierMaps = await getAll();
      final persons = await _getPersons();
      final establishments = await _getEstablishments();

      for (final applierMap in applierMaps) {
        final person = persons.firstWhere((p) {
          return p.id == applierMap["person"];
        });

        final establishment = establishments.firstWhere((e) {
          return e.id == applierMap["establishment"];
        });

        applierMap["person"] = person.toMap();
        applierMap["person"]["locality"] = person.locality?.toMap();

        applierMap["establishment"] = establishment.toMap();
        applierMap["establishment"]["locality"] =
            establishment.locality.toMap();
      }

      final appliers = applierMaps.map((applier) {
        return Applier.fromMap(applier);
      }).toList();

      return appliers;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Establishment>> _getEstablishments() async {
    final establishments = await _establishmentRepo.getEstablishments();

    return establishments;
  }

  Future<List<Person>> _getPersons() async {
    final persons = await _personRepo.getPersons();

    return persons;
  }

  @override
  Future<int> updateApplier(Applier applier) async {
    int updatedRows = await _establishmentRepo.updateEstablishment(
      applier.establishment,
    );
    if (updatedRows != 1) return 0;

    updatedRows += await _personRepo.updatePerson(applier.person);
    if (updatedRows != 2) return 0;

    updatedRows += await update(applier.toMap());
    if (updatedRows != 3) return 0;

    return updatedRows;
  }
}
