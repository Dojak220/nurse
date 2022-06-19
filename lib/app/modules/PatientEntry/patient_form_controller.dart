import 'package:flutter/material.dart';
import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/repositories/database/patient/database_patient_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/patient/patient_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_category_repository.dart';
import 'package:nurse/shared/utils/validator.dart';

class PatientFormController extends FormController {
  final PriorityCategoryRepository _priorityCategoryRepository;
  final PatientRepository _patientRepository;
  final _categories = List<PriorityCategory>.empty(growable: true);
  List<PriorityCategory> get categories => _categories;

  Patient? patient;

  TextEditingController cns = TextEditingController();
  TextEditingController cpf = TextEditingController();
  TextEditingController name = TextEditingController();
  Sex? sex;
  PriorityCategory? selectedCategory;
  MaternalCondition? maternalCondition;

  PatientFormController([
    PatientRepository? patientRepository,
    PriorityCategoryRepository? priorityCategoryRepository,
  ])  : _patientRepository = patientRepository ?? DatabasePatientRepository(),
        _priorityCategoryRepository =
            priorityCategoryRepository ?? DatabasePriorityCategoryRepository() {
    _getCategories();
  }

  void _getCategories() async {
    _categories
        .addAll(await _priorityCategoryRepository.getPriorityCategories());
  }

  Future<void> findPatientByCpf(String? cpf) async {
    bool isCpfValid = false;
    try {
      isCpfValid = cpf != null && Validator.validate(ValidatorType.CNS, cpf);
    } catch (e) {
      return;
    }

    if (isCpfValid) {
      patient = await _patientRepository.getPatientByCns(cpf);
      if (patient != null) {
        _setPatientAndNotify(patient!);
      }
    }
  }

  Future<void> findPatientByCns(String? cns) async {
    bool isCnsValid = false;
    try {
      isCnsValid = cns != null && Validator.validate(ValidatorType.CNS, cns);

      if (isCnsValid) {
        patient = await _patientRepository.getPatientByCns(cns);
        if (patient != null) _setPatientAndNotify(patient!);
      }
    } catch (e) {
      return;
    }
  }

  void _setPatientAndNotify(Patient patient) {
    cns.text = patient.cns;
    cpf.text = patient.person.cpf;
    name.text = patient.person.name;
    sex = patient.person.sex;
    selectedCategory = patient.priorityCategory;
    maternalCondition = patient.maternalCondition;

    notifyListeners();
  }

  void cleanAllInfo() {
    patient = null;
    cns.text = "";
    cpf.text = "";
    name.text = "";
    sex = null;
    selectedCategory = null;
    maternalCondition = null;
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();

    patient = Patient(
      cns: cns.text,
      priorityCategory: selectedCategory!,
      maternalCondition: maternalCondition!,
      person: Person(cpf: cpf.text, name: name.text),
    );
  }
}
