import 'package:nurse/shared/models/patient/patient_model.dart';

abstract class PatientRepository {
  Future<int> createPatient(Patient locality);
  Future<void> deletePatient(int id);
  Future<Patient> getPatientById(int id);
  Future<List<Patient>> getPatients();
  Future<int> updatePatient(Patient locality);
}
