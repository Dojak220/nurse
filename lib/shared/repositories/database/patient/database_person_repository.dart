import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';
import 'package:nurse/shared/repositories/patient/person_repository.dart';

class DatabasePersonRepository extends DatabaseInterface
    implements PersonRepository {
  static const String TABLE = "Person";
  final LocalityRepository localityRepo;

  DatabasePersonRepository({
    DatabaseManager? dbManager,
    required this.localityRepo,
  }) : super(TABLE, dbManager);

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
    final locality = await localityRepo.getLocalityById(id);

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

        p["locality"] = locality.toMap();
      });

      final persons = personMaps.map((person) {
        return Person.fromMap(person);
      }).toList();

      return persons;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Locality>> _getLocalities() async {
    final localities = await localityRepo.getLocalities();

    return localities;
  }

  @override
  Future<int> updatePerson(Person person) async {
    final int updatedCount = await update(person.toMap());

    return updatedCount;
  }
}
