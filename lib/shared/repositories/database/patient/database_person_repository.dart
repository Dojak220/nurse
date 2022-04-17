import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/patient/person_repository.dart';

class DatabasePersonRepository extends DatabaseInterface
    implements PersonRepository {
  static const String TABLE = "Person";
  final DatabaseManager dbManager;

  DatabasePersonRepository(this.dbManager) : super(dbManager, TABLE);

  @override
  Future<int> createPerson(Person person) async {
    final int result = await create(person.toMap());

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
      final personMap = await get(id);

      final locality = await _getLocality(personMap["locality"]);

      personMap["locality"] = locality.toMap();

      final person = Person.fromMap(personMap);

      return person;
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
  Future<List<Person>> getPersons() async {
    try {
      final personMaps = await getAll();
      final localities = await _getLocalities();

      personMaps.forEach((p) {
        final locality = localities.firstWhere((l) {
          return l.id == p["locality"];
        });

        p["locality"] = locality;
      });

      final persons = personMaps.map((person) {
        return Person.fromMap(person);
      }).toList();

      return persons;
    } catch (e) {
      return List<Person>.empty();
    }
  }

  Future<List<Locality>> _getLocalities() async {
    final dbRepo = DatabaseLocalityRepository(dbManager);
    final localities = await dbRepo.getLocalities();

    return localities;
  }

  @override
  Future<int> updatePerson(Person person) async {
    final int updatedCount = await update(person.toMap());

    return updatedCount;
  }
}
