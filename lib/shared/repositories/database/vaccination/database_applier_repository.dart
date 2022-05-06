import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_person_repository.dart';
import 'package:nurse/shared/repositories/vaccination/applier_repository.dart';

class DatabaseApplierRepository extends DatabaseInterface
    implements ApplierRepository {
  static const String TABLE = "Applier";

  DatabaseApplierRepository() : super(TABLE);

  @override
  Future<int> createApplier(Applier applier) async {
    final int result = await create(applier.toMap());

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
      final applierMap = await get(id);

      final person = await _getPerson(applierMap["person"]);
      final establishment = await _getEstablishment(
        applierMap["establishment"],
      );

      applierMap["person"] = person.toMap();
      applierMap["establishment"] = establishment.toMap();

      final applier = Applier.fromMap(applierMap);

      return applier;
    } catch (e) {
      rethrow;
    }
  }

  Future<Establishment> _getEstablishment(int id) async {
    final dbRepo = DatabaseEstablishmentRepository();
    final establishment = await dbRepo.getEstablishmentById(id);

    return establishment;
  }

  Future<Person> _getPerson(int id) async {
    final dbRepo = DatabasePersonRepository();
    final person = await dbRepo.getPersonById(id);

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

        a["person"] = person;
        a["establishment"] = establishment;
      });

      final appliers = applierMaps.map((applier) {
        return Applier.fromMap(applier);
      }).toList();

      return appliers;
    } catch (e) {
      return List<Applier>.empty();
    }
  }

  Future<List<Establishment>> _getEstablishments() async {
    final dbRepo = DatabaseEstablishmentRepository();
    final establishments = await dbRepo.getEstablishments();

    return establishments;
  }

  Future<List<Person>> _getPersons() async {
    final dbRepo = DatabasePersonRepository();
    final persons = await dbRepo.getPersons();

    return persons;
  }

  @override
  Future<int> updateApplier(Applier applier) async {
    final int updatedCount = await update(applier.toMap());

    return updatedCount;
  }
}
