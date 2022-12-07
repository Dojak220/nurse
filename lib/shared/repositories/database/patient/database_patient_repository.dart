import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/patient/database_person_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/patient/patient_repository.dart';
import 'package:nurse/shared/repositories/patient/person_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_category_repository.dart';

class DatabasePatientRepository extends DatabaseInterface
    implements PatientRepository {
  // ignore: constant_identifier_names
  static const String TABLE = "Patient";
  final PersonRepository _personRepo;
  final PriorityCategoryRepository _categoryRepo;

  DatabasePatientRepository({
    DatabaseManager? dbManager,
    PersonRepository? personRepo,
    PriorityCategoryRepository? categoryRepo,
  })  : _personRepo = personRepo ?? DatabasePersonRepository(),
        _categoryRepo = categoryRepo ?? DatabasePriorityCategoryRepository(),
        super(TABLE, dbManager);

  @override
  Future<int> createPatient(Patient patient) async {
    final map = patient.toMap();

    map['person'] = await _personRepo.createPerson(patient.person);
    map['priority_category'] = await _categoryRepo
        .getPriorityCategoryByCode(patient.priorityCategory.code)
        .then((priorityCategory) => priorityCategory.id!);

    final int result = await create(map);

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
      return _getPatientFromMap(await getById(id));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Patient> getPatientByCns(String cns) async {
    try {
      return _getPatientFromMap(
        await get(objs: [cns], where: "cns = ?").then(
          (maps) => maps.single,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Patient> getPatientByCpf(String cpf) async {
    try {
      final person = await _getPersonByCpf(cpf);
      if (person == null) throw Exception("Paciente não encontrado");

      final patientMap = await get(objs: [person.id], where: "person = ?").then(
        (maps) => maps.single,
      );

      final patient = await _getPatientFromMap(patientMap, person);

      return patient;
    } catch (e) {
      rethrow;
    }
  }

  Future<Patient> _getPatientFromMap(
    Map<String, dynamic> patientMap, [
    Person? person,
  ]) async {
    final p = person ?? await _getPersonById(patientMap["person"] as int);
    final priorityCategory = await _getPriorityCategory(
      patientMap["priority_category"] as int,
    );

    final updatedPatientMap = Map.of(patientMap);

    updatedPatientMap["person"] = p.toMap();
    updatedPatientMap["person"]["locality"] = p.locality?.toMap();

    updatedPatientMap["priority_category"] = priorityCategory.toMap();
    updatedPatientMap["priority_category"]["priority_group"] =
        priorityCategory.priorityGroup.toMap();

    return Patient.fromMap(updatedPatientMap);
  }

  Future<Person> _getPersonById(int id) async {
    final person = await _personRepo.getPersonById(id);

    return person;
  }

  Future<Person?> _getPersonByCpf(String cpf) async {
    Person? person;
    try {
      person = await _personRepo.getPersonByCpf(cpf);
    } catch (e) {
      rethrow;
    }

    return person;
  }

  Future<PriorityCategory> _getPriorityCategory(int id) async {
    final priorityCategory = await _categoryRepo.getPriorityCategoryById(id);

    return priorityCategory;
  }

  @override
  Future<List<Patient>> getPatients() async {
    try {
      final patientMaps = await getAll();
      final persons = await _getPersons();
      final priorityCategories = await _getPriorityCategories();

      for (final patientMap in patientMaps) {
        final person = persons.firstWhere((per) {
          return per.id == patientMap["person"];
        });
        final priorityCategory = priorityCategories.firstWhere((c) {
          return c.id == patientMap["priority_category"];
        });

        patientMap["person"] = person.toMap();
        patientMap["person"]["locality"] = person.locality?.toMap();

        patientMap["priority_category"] = priorityCategory.toMap();
        patientMap["priority_category"]["priority_group"] =
            priorityCategory.priorityGroup.toMap();
      }

      final patients = patientMaps
          .map(
            (patient) => Patient.fromMap(patient),
          )
          .toList();

      return patients;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Person>> _getPersons() async {
    final persons = await _personRepo.getPersons();

    return persons;
  }

  Future<List<PriorityCategory>> _getPriorityCategories() async {
    final priorityCategories = await _categoryRepo.getPriorityCategories();

    return priorityCategories;
  }

  @override
  Future<int> updatePatient(Patient patient) async {
    int updatedRows = await _personRepo.updatePerson(patient.person);
    if (updatedRows != 1) return 0;

    updatedRows +=
        await _categoryRepo.updatePriorityCategory(patient.priorityCategory);
    if (updatedRows != 2) return 0;

    updatedRows += await update(patient.toMap());
    if (updatedRows != 3) return 0;

    return updatedRows;
  }
}
