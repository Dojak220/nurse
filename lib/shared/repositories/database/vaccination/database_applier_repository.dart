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
      return _getApplierFromMap(await get(cns, where: "cns = ?"));
    } catch (e) {
      rethrow;
    }
  }

  Future<Applier> _getApplierFromMap(Map<String, dynamic> applierMap) async {
    final person = await _getPerson(applierMap["person"]);
    final establishment = await _getEstablishment(applierMap["establishment"]);

    final updatedApplierMap = Map.of(applierMap);
    updatedApplierMap["person"] = person.toMap();
    updatedApplierMap["establishment"] = establishment.toMap();

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

      applierMaps.forEach((a) {
        final person = persons.firstWhere((p) {
          return p.id == a["person"];
        });

        final establishment = establishments.firstWhere((e) {
          return e.id == a["establishment"];
        });

        a["person"] = person.toMap();
        a["establishment"] = establishment.toMap();
      });

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
    final int updatedCount = await update(applier.toMap());

    return updatedCount;
  }
}
