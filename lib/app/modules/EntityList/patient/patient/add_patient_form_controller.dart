import "dart:async";

import "package:mobx/mobx.dart";
import "package:nurse/app/modules/EntityList/patient/patient/patient_store.dart";
import "package:nurse/app/utils/add_form_controller.dart";
import "package:nurse/shared/models/infra/locality_model.dart";
import "package:nurse/shared/models/patient/patient_model.dart";
import "package:nurse/shared/models/patient/person_model.dart";
import "package:nurse/shared/models/patient/priority_category_model.dart";
import "package:nurse/shared/repositories/database/infra/database_locality_repository.dart";
import "package:nurse/shared/repositories/database/patient/database_patient_repository.dart";
import "package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart";
import "package:nurse/shared/repositories/infra/locality_repository.dart";
import "package:nurse/shared/repositories/patient/patient_repository.dart";
import "package:nurse/shared/repositories/patient/priority_category_repository.dart";

part "add_patient_form_controller.g.dart";

class AddPatientFormController = _AddPatientFormControllerBase
    with _$AddPatientFormController;

abstract class _AddPatientFormControllerBase extends AddFormController
    with Store {
  final LocalityRepository _localityRepository;
  final PriorityCategoryRepository _priorityCategoryRepository;
  final PatientRepository _repository;

  final Patient? initialPatientInfo;

  @observable
  ObservableList<Locality> localities = ObservableList.of(
    List<Locality>.empty(growable: true),
  );

  @observable
  ObservableList<PriorityCategory> categories = ObservableList.of(
    List<PriorityCategory>.empty(growable: true),
  );

  @observable
  PatientStore patientStore = PatientStore();

  _AddPatientFormControllerBase(
    this.initialPatientInfo, [
    LocalityRepository? localityRepository,
    PriorityCategoryRepository? priorityCategoryRepository,
    PatientRepository? patientRepository,
  ])  : _localityRepository =
            localityRepository ?? DatabaseLocalityRepository(),
        _priorityCategoryRepository =
            priorityCategoryRepository ?? DatabasePriorityCategoryRepository(),
        _repository = patientRepository ?? DatabasePatientRepository() {
    if (initialPatientInfo != null) {
      patientStore.setInfo(initialPatientInfo!);
    }

    getLocalities();
    getPriorityCategories();
  }

  @action
  Future<List<Locality>> getLocalities() async {
    final localities = await _localityRepository.getLocalities();

    this.localities
      ..clear()
      ..addAll(localities);

    return localities;
  }

  @action
  Future<List<PriorityCategory>> getPriorityCategories() async {
    final priorityCategories =
        await _priorityCategoryRepository.getPriorityCategories();

    categories
      ..clear()
      ..addAll(priorityCategories);

    return priorityCategories;
  }

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final newPatient = Patient(
        cns: patientStore.cns!,
        person: Person(
          cpf: patientStore.cpf!,
          name: patientStore.name!,
          locality: patientStore.selectedLocality,
          sex: patientStore.selectedSex,
          birthDate: patientStore.selectedBirthDate,
          fatherName: patientStore.fatherName!,
          motherName: patientStore.motherName!,
        ),
        maternalCondition: patientStore.selectedMaternalCondition,
        priorityCategory: patientStore.selectedPriorityCategory!,
      );

      return super.createEntity<Patient>(newPatient, _repository.createPatient);
    } else {
      return false;
    }
  }

  @override
  Future<bool> updateInfo() async {
    if (initialPatientInfo == null) return false;

    if (submitForm(formKey)) {
      final updatedPatient = initialPatientInfo!.copyWith(
        cns: patientStore.cns,
        person: initialPatientInfo!.person.copyWith(
          cpf: patientStore.cpf,
          name: patientStore.name,
          locality: patientStore.selectedLocality,
          sex: patientStore.selectedSex,
          birthDate: patientStore.selectedBirthDate,
          fatherName: patientStore.fatherName,
          motherName: patientStore.motherName,
        ),
        maternalCondition: patientStore.selectedMaternalCondition,
        priorityCategory: patientStore.selectedPriorityCategory,
      );

      return super.updateEntity<Patient>(
        updatedPatient,
        _repository.updatePatient,
      );
    } else {
      return false;
    }
  }

  @override
  void clearAllInfo() {
    patientStore.clearAllInfo();
  }

  @override
  void dispose() {
    /// Não tem o que ser desalocado aqui
  }
}
