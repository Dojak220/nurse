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

  AddPatientFormController([
    LocalityRepository? localityRepository,
    PriorityCategoryRepository? priorityCategoryRepository,
    PatientRepository? patientRepository,
  ])  : _localityRepository =
            localityRepository ?? DatabaseLocalityRepository(),
        _priorityCategoryRepository =
            priorityCategoryRepository ?? DatabasePriorityCategoryRepository(),
        _repository = patientRepository ?? DatabasePatientRepository();

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

  Future<bool> saveInfo() async {
    submitForm();
    final allFieldsValid = super.formKey.currentState!.validate();

    if (allFieldsValid) {
      try {
        final id = await _repository.createPatient(
          Patient(
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
          ),
        );

        if (id != 0) {
          clearAllInfo();
          return true;
        } else {
          return false;
        }
      } catch (error) {
        print(error);
        return false;
      }
    }

    return false;
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

  @override
  void submitForm() async {
    formKey.currentState!.save();
  }
}
