import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';
import 'package:nurse/shared/repositories/patient/person_repository.dart';

class DatabasePersonRepository extends DatabaseInterface
    implements PersonRepository {
  static const String TABLE = "Person";
  final LocalityRepository _localityRepo;

  DatabasePersonRepository(
      {DatabaseManager? dbManager, LocalityRepository? localityRepo})
      : _localityRepo = localityRepo ?? DatabaseLocalityRepository(),
        super(TABLE, dbManager);

  @override
  Future<int> createPerson(Person person) async {
    final map = person.toMap();

    map['locality'] = person.locality != null
        ? await _localityRepo
            .getLocalityByIbgeCode(person.locality!.ibgeCode)
            .then((locality) => locality.id)
        : null;

    final int result = await create(map);

    return result;
  }

  @override
  Future<int> deletePerson(int id) async {
    final int deletedCount = await delete(id);

    return deletedCount;
  }

  @override
  Future<Person> getPersonById(int id) async {
    try {
      return _getPersonFromMap(await getById(id));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Person> getPersonByCpf(String cpf) async {
    try {
      return _getPersonFromMap(
        await get(objs: [cpf], where: "cpf = ?").then(
          (maps) => maps.single,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Person> _getPersonFromMap(Map<String, dynamic> personMap) async {
    final locality = await _getLocality(personMap["locality"]);

    final updatedPersonMap = Map.of(personMap);
    updatedPersonMap["locality"] = locality.toMap();

    return Person.fromMap(updatedPersonMap);
  }

  Future<Locality> _getLocality(int id) async {
    final locality = await _localityRepo.getLocalityById(id);

    return locality;
  }

  @override
  Future<List<Person>> getPersons() async {
    try {
      final personMaps = await getAll();

      await Future.forEach(personMaps, (Map<String, dynamic> p) async {
        final result = p["locality"] != null
            ? await _localityRepo.getLocalityById(p["locality"])
            : null;

        p["locality"] = result?.toMap();
      });

      final persons = personMaps.map((person) {
        return Person.fromMap(person);
      }).toList();

      return persons;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updatePerson(Person person) async {
    final int updatedCount = await update(person.toMap());

    return updatedCount;
  }
}
