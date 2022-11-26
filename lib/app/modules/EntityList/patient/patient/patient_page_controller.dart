import 'package:mobx/mobx.dart';
import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/repositories/database/patient/database_patient_repository.dart';
import 'package:nurse/shared/repositories/patient/patient_repository.dart';

part 'patient_page_controller.g.dart';

class PatientsPageController = _PatientsPageControllerBase
    with _$PatientsPageController;

abstract class _PatientsPageControllerBase extends EntityPageController<Patient>
    with Store {
  final PatientRepository patientRepository;

  @observable
  bool isLoading = true;

  _PatientsPageControllerBase()
      : patientRepository = DatabasePatientRepository() {
    getPatients();
  }

  @action
  Future<List<Patient>> getPatients() async {
    final result = await patientRepository.getPatients();

    entities
      ..clear()
      ..addAll(
        result..sort((a, b) => a.person.name.compareTo(b.person.name)),
      );

    isLoading = false;

    return entities;
  }
}
