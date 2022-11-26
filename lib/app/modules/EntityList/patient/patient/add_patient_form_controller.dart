import 'package:flutter/material.dart';
import 'package:nurse/app/utils/add_form_controller.dart';
import 'package:nurse/app/utils/date_picker.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_patient_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';
import 'package:nurse/shared/repositories/patient/patient_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_category_repository.dart';

class AddPatientFormController extends AddFormController {
  final LocalityRepository _localityRepository;
  final PriorityCategoryRepository _priorityCategoryRepository;
  final PatientRepository _repository;

  final Patient? initialPatientInfo;

  Locality? selectedLocality;
  PriorityCategory? selectedPriorityCategory;
  Sex selectedSex = Sex.none;
  MaternalCondition selectedMaternalCondition = MaternalCondition.nenhum;
  DateTime? selectedBirthDate;
  TextEditingController cns = TextEditingController();
  TextEditingController cpf = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController motherName = TextEditingController();
  TextEditingController fatherName = TextEditingController();

  AddPatientFormController(
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
      setInfo(initialPatientInfo!);
    }
  }

  Future<List<Locality>> getLocalities() async {
    final localities = await _localityRepository.getLocalities();

    return localities;
  }

  Future<List<PriorityCategory>> getPriorityCategories() async {
    final priorityCategories =
        await _priorityCategoryRepository.getPriorityCategories();

    return priorityCategories;
  }

  Future<void> selectDate(BuildContext context) async {
    final newSelectedDate =
        await DatePicker.getNewDate(context, selectedBirthDate);

    if (newSelectedDate != null) {
      selectedBirthDate = newSelectedDate;
      birthDate
        ..text = DatePicker.formatDateDDMMYYYY(selectedBirthDate!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: birthDate.text.length, affinity: TextAffinity.upstream));
    }
  }

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final newPatient = Patient(
        cns: cns.text,
        person: Person(
          cpf: cpf.text,
          name: name.text,
          locality: selectedLocality,
          sex: selectedSex,
          birthDate: selectedBirthDate,
          fatherName: fatherName.text,
          motherName: motherName.text,
        ),
        maternalCondition: selectedMaternalCondition,
        priorityCategory: selectedPriorityCategory!,
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
        cns: cns.text,
        person: Person(
          cpf: cpf.text,
          name: name.text,
          locality: selectedLocality,
          sex: selectedSex,
          birthDate: selectedBirthDate,
          fatherName: fatherName.text,
          motherName: motherName.text,
        ),
        maternalCondition: selectedMaternalCondition,
        priorityCategory: selectedPriorityCategory!,
      );

      return super.updateEntity<Patient>(
        updatedPatient,
        _repository.updatePatient,
      );
    } else {
      return false;
    }
  }

  void setInfo(Patient patient) {
    cns.text = patient.cns;

    name.text = patient.person.name;
    cpf.text = patient.person.cpf;
    selectedLocality = patient.person.locality;
    selectedSex = patient.person.sex;

    selectedBirthDate = patient.person.birthDate;
    birthDate.text = DatePicker.formatDateDDMMYYYY(selectedBirthDate!);

    fatherName.text = patient.person.fatherName;
    motherName.text = patient.person.motherName;

    selectedPriorityCategory = patient.priorityCategory;
    selectedMaternalCondition = patient.maternalCondition;
  }

  @override
  void clearAllInfo() {
    selectedLocality = null;
    selectedPriorityCategory = null;
    selectedSex = Sex.none;
    selectedMaternalCondition = MaternalCondition.nenhum;
    selectedBirthDate = null;

    cns.clear();
    cpf.clear();
    name.clear();
    birthDate.clear();
    motherName.clear();
    fatherName.clear();

    notifyListeners();
  }
}
