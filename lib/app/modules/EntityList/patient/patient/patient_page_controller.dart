import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/repositories/database/patient/database_patient_repository.dart';
import 'package:nurse/shared/repositories/patient/patient_repository.dart';

class PatientsPageController extends EntityPageController<Patient> {
  final PatientRepository patientRepository;

  PatientsPageController() : patientRepository = DatabasePatientRepository() {
    getPatients();
  }

  Future<List<Patient>> getPatients() async {
    final result = await patientRepository.getPatients();

    entities
      ..clear()
      ..addAll(result..sort((a, b) => a.person.name.compareTo(b.person.name)));

    return entities;
  }
}
