import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/patient/database_person_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/patient/patient_repository.dart';

class DatabasePatientRepository extends DatabaseInterface
    implements PatientRepository {
  static const String TABLE = "Patient";
  final DatabaseManager dbManager;

  DatabasePatientRepository(this.dbManager) : super(dbManager, TABLE);

  @override
  Future<int> createPatient(Patient patient) async {
    final int result = await create(patient.toMap());

    return result;
  }

  @override
  Future<int> deletePatient(int id) async {
    final int deletedCount = await delete(id);

    return deletedCount;
  }

  @override
  Future<Patient> getPatientById(int id) async {
    try {
      final patientMap = await get(id);

      final person = await _getPerson(patientMap["person"]);
      final priorityCategory = await _getPriorityCategory(
        patientMap["priorityCategory"],
      );

      patientMap['person'] = person.toMap();
      patientMap['priorityCategory'] = priorityCategory.toMap();

      final patient = Patient.fromMap(patientMap);

      return patient;
    } catch (e) {
      rethrow;
    }
  }

  Future<Person> _getPerson(int id) async {
    final dbRepo = DatabasePersonRepository(dbManager);
    final person = await dbRepo.getPersonById(id);

    return person;
  }

  Future<PriorityCategory> _getPriorityCategory(int id) async {
    final dbRepo = DatabasePriorityCategoryRepository(dbManager);
    final priorityCategory = await dbRepo.getPriorityCategoryById(id);

    return priorityCategory;
  }

  @override
  Future<List<Patient>> getPatients() async {
    try {
      final patientMaps = await getAll();
      final persons = await _getPersons();
      final priorityCategories = await _getPriorityCategories();

      patientMaps.forEach((pat) {
        final person = persons.firstWhere((per) {
          return per.id == pat["person"];
        });
        final priorityCategory = priorityCategories.firstWhere((c) {
          return c.id == pat["priorityCategory"];
        });

        pat["person"] = person;
        pat["priorityCategory"] = priorityCategory;
      });

      final patients = patientMaps
          .map(
            (patient) => Patient.fromMap(patient),
          )
          .toList();

      return patients;
    } catch (e) {
      return List<Patient>.empty();
    }
  }

  Future<List<Person>> _getPersons() async {
    final dbRepo = DatabasePersonRepository(dbManager);
    final persons = await dbRepo.getPersons();

    return persons;
  }

  Future<List<PriorityCategory>> _getPriorityCategories() async {
    final dbRepo = DatabasePriorityCategoryRepository(dbManager);
    final priorityCategories = await dbRepo.getPriorityCategories();

    return priorityCategories;
  }

  @override
  Future<int> updatePatient(Patient patient) async {
    final int updatedCount = await update(patient.toMap());

    return updatedCount;
  }
}
