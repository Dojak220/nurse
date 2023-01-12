import "package:flutter/material.dart";
import "package:mobx/mobx.dart";
import "package:nurse/app/utils/form_controller.dart";
import "package:nurse/shared/models/patient/patient_model.dart";
import "package:nurse/shared/models/patient/person_model.dart";
import "package:nurse/shared/models/patient/priority_category_model.dart";
import "package:nurse/shared/repositories/database/patient/database_patient_repository.dart";
import "package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart";
import "package:nurse/shared/repositories/patient/patient_repository.dart";
import "package:nurse/shared/repositories/patient/priority_category_repository.dart";
import "package:nurse/shared/utils/validator.dart";

part "patient_form_controller.g.dart";

class PatientFormController = _PatientFormControllerBase
    with _$PatientFormController;

abstract class _PatientFormControllerBase extends FormController with Store {
  final PriorityCategoryRepository _priorityCategoryRepository;
  final PatientRepository _patientRepository;

  final _categories = List<PriorityCategory>.empty(growable: true);
  List<PriorityCategory> get categories => _categories;

  Patient? _patient;

  TextEditingController cns = TextEditingController();
  TextEditingController cpf = TextEditingController();
  TextEditingController name = TextEditingController();

  @observable
  Sex? sex;

  @observable
  PriorityCategory? selectedCategory;

  @observable
  MaternalCondition maternalCondition = MaternalCondition.nenhum;

  _PatientFormControllerBase([
    PatientRepository? patientRepository,
    PriorityCategoryRepository? priorityCategoryRepository,
  ])  : _patientRepository = patientRepository ?? DatabasePatientRepository(),
        _priorityCategoryRepository =
            priorityCategoryRepository ?? DatabasePriorityCategoryRepository() {
    _getCategories();
    notifyListeners();
  }

  Future<void> _getCategories() async {
    _categories.addAll(
      await _priorityCategoryRepository.getPriorityCategories(),
    );
  }

  Future<void> findPatientByCpf(String? cpf) async {
    bool isCpfValid = false;
    try {
      isCpfValid = cpf != null && Validator.validate(ValidatorType.cpf, cpf);
    } catch (e) {
      return;
    }

    if (isCpfValid) {
      try {
        _patient = await _patientRepository.getPatientByCpf(cpf);
      } catch (e) {
        _patient = null;
      }

      if (_patient != null) setPatient(_patient!);
    }
  }

  Future<void> findPatientByCns(String? cns) async {
    bool isCnsValid = false;
    try {
      isCnsValid = cns != null && Validator.validate(ValidatorType.cns, cns);

      if (isCnsValid) {
        _patient = await _patientRepository.getPatientByCns(cns);
        if (_patient != null) setPatient(_patient!);
      }
    } catch (e) {
      return;
    }
  }

  @action
  void setPatient(Patient patient) {
    cns.text = patient.cns;
    cpf.text = patient.person.cpf;
    name.text = patient.person.name;
    sex = patient.person.sex;
    selectedCategory = patient.priorityCategory;
    maternalCondition = patient.maternalCondition;
  }

  Patient? get patient {
    if (_allFieldsFulfilled) {
      return _patient;
    }
    return null;
  }

  bool get _allFieldsFulfilled {
    return cns.text.isNotEmpty &&
        cpf.text.isNotEmpty &&
        name.text.isNotEmpty &&
        sex != null &&
        selectedCategory != null;
  }

  @override
  void clearAllInfo() {
    _patient = null;
    cns.clear();
    cpf.clear();
    name.clear();
    sex = null;
    selectedCategory = null;
    maternalCondition = MaternalCondition.nenhum;

    notifyListeners();
  }

  @override
  bool submitForm(GlobalKey<FormState> formKey) {
    final result = super.submitForm(formKey);

    if (result) {
      _patient = _patient?.copyWith(
            id: _patient?.id,
            cns: cns.text,
            priorityCategory: selectedCategory,
            maternalCondition: maternalCondition,
            person: _patient!.person.copyWith(cpf: cpf.text, name: name.text),
          ) ??
          Patient(
            id: _patient?.id,
            cns: cns.text,
            priorityCategory: selectedCategory!,
            maternalCondition: maternalCondition,
            person: _patient?.person.copyWith(cpf: cpf.text, name: name.text) ??
                Person(cpf: cpf.text, name: name.text),
          );

      _saveOrUpdatePatient();
    }

    return result;
  }

  Future<void> _saveOrUpdatePatient() async {
    if (patient == null) return;

    if (patient!.id == null) {
      await _patientRepository.createPatient(patient!);
    } else {
      await _patientRepository.updatePatient(patient!);
    }
  }

  @override
  void dispose() {
    cns.dispose();
    cpf.dispose();
    name.dispose();
  }
}
