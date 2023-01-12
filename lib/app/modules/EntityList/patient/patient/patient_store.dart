import "package:flutter/material.dart";
import "package:mobx/mobx.dart";
import "package:nurse/app/utils/date_picker.dart";
import "package:nurse/shared/models/infra/locality_model.dart";
import "package:nurse/shared/models/patient/patient_model.dart";
import "package:nurse/shared/models/patient/person_model.dart";
import "package:nurse/shared/models/patient/priority_category_model.dart";

part "patient_store.g.dart";

class PatientStore = _PatientStoreBase with _$PatientStore;

abstract class _PatientStoreBase with Store {
  @observable
  Locality? selectedLocality;

  @observable
  PriorityCategory? selectedPriorityCategory;

  @observable
  Sex selectedSex = Sex.none;

  @observable
  MaternalCondition selectedMaternalCondition = MaternalCondition.nenhum;

  @observable
  DateTime? selectedBirthDate;

  @observable
  String? cns;

  @observable
  String? cpf;

  @observable
  String? name;

  @observable
  String? birthDate;

  @observable
  String? motherName;

  @observable
  String? fatherName;

  @action
  void setLocality(Locality? value) => selectedLocality = value;

  @action
  void setPriorityCategory(PriorityCategory? value) =>
      selectedPriorityCategory = value;

  @action
  void setSex(Sex value) => selectedSex = value;

  @action
  void setMaternalCondition(MaternalCondition value) =>
      selectedMaternalCondition = value;

  @action
  void setSelectedBirthDate(DateTime? value) => selectedBirthDate = value;

  @action
  void setCpf(String value) => cpf = value;

  @action
  void setCns(String value) => cns = value;

  @action
  void setName(String value) => name = value;

  @action
  void setBirthDate(String value) => birthDate = value;

  @action
  void setMotherName(String value) => motherName = value;

  @action
  void setFatherName(String value) => fatherName = value;

  @action
  Future<void> selectDate(BuildContext context) async {
    final newSelectedDate =
        await DatePicker.getNewDate(context, selectedBirthDate);

    if (newSelectedDate != null) {
      selectedBirthDate = newSelectedDate;
      birthDate = DatePicker.formatDateDDMMYYYY(selectedBirthDate!);
    }
  }

  @action
  void setInfo(Patient patient) {
    cns = patient.cns;

    name = patient.person.name;
    cpf = patient.person.cpf;
    selectedLocality = patient.person.locality;
    selectedSex = patient.person.sex;

    selectedBirthDate = patient.person.birthDate;
    birthDate = DatePicker.formatDateDDMMYYYY(selectedBirthDate!);

    fatherName = patient.person.fatherName;
    motherName = patient.person.motherName;

    selectedPriorityCategory = patient.priorityCategory;
    selectedMaternalCondition = patient.maternalCondition;
  }

  @action
  void clearAllInfo() {
    selectedLocality = null;
    selectedPriorityCategory = null;
    selectedSex = Sex.none;
    selectedMaternalCondition = MaternalCondition.nenhum;
    selectedBirthDate = null;

    cns = null;
    cpf = null;
    name = null;
    birthDate = null;
    motherName = null;
    fatherName = null;
  }
}
