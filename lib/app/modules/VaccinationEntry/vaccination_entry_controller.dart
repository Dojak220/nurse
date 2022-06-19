import 'package:flutter/material.dart';
import 'package:nurse/app/modules/ApplierEntry/applier_form_controller.dart';
import 'package:nurse/app/modules/CampaignEntry/campaign_form_controller.dart';
import 'package:nurse/app/modules/PatientEntry/patient_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/application_form_controller.dart';
import 'package:nurse/app/modules/VaccineEntry/vaccine_form_controller.dart';
import 'package:nurse/app/utils/form_controller.dart';

class VaccinationEntryController {
  final _formKey = GlobalKey<FormState>();

  final int formsCount = 5;
  int _formIndex = 0;
  int get formIndex => _formIndex;

  GlobalKey<FormState> get formKey => _formKey;

  final campaignFormController = CampaignFormController();
  final patientFormController = PatientFormController();
  final applierFormController = ApplierFormController();
  final vaccineFormController = VaccineFormController();
  final applicationFormController = ApplicationFormController();

  late final String doseValue;
  late final DateTime? dateValue;

  bool get isLastForm => _formIndex == formsCount - 1;

  VaccinationEntryController();

  FormController getFormController() {
    switch (formIndex) {
      case 0:
        return campaignFormController;
      case 1:
        return patientFormController;
      case 2:
        return applierFormController;
      case 3:
        return vaccineFormController;
      case 4:
        return applicationFormController;
      default:
        throw Exception('Unknown form index');
    }
  }

  void updateFormIndex(int index) {
    _formIndex = index;
  }

  void previousForm() {
    if (_formIndex > 0) {
      updateFormIndex(_formIndex - 1);
    }
  }

  void nextForm() {
    final formController = getFormController();
    final wasSubmited = submitIfFormValid(formController);

    if (wasSubmited) updateFormIndex(_formIndex + 1);
  }

  bool cleanAllForms() {
    campaignFormController.cleanAllInfo();
    patientFormController.cleanAllInfo();
    applierFormController.cleanAllInfo();
    vaccineFormController.cleanAllInfo();
    applicationFormController.cleanAllInfo();

    return true;
  }

  bool submitIfFormValid(FormController formController) {
    final allFieldsValid = formController.formKey.currentState!.validate();
    if (allFieldsValid) {
      formController.submitForm();
      return true;
    }
    return false;
  }

  void saveVaccination() {
    print('Saving vaccination');
  }

  void submitForm() {
    formKey.currentState!.save();
  }
}
