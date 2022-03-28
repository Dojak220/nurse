import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/patient_repository.dart';

class DatabasePatientRepository extends DatabaseInterface
    implements PatientRepository {
  static const String TABLE = "patient";
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
      final patient = Patient.fromMap(patientMap);

      return patient;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Patient>> getPatients() async {
    try {
      final patientMaps = await getAll();

      final List<Patient> patients = List<Patient>.generate(
        patientMaps.length,
        (index) {
          return Patient.fromMap(patientMaps[index]);
        },
      );

      return patients;
    } catch (e) {
      return List<Patient>.empty();
    }
  }

  @override
  Future<int> updatePatient(Patient patient) async {
    final int updatedCount = await update(patient.toMap());

    return updatedCount;
  }
}
