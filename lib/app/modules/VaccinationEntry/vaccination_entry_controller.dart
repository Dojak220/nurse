import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/Forms/ApplicationEntry/application_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/Forms/ApplierEntry/applier_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/Forms/CampaignEntry/campaign_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/Forms/PatientEntry/patient_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/Forms/VaccineEntry/vaccine_form_controller.dart';
import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_application_repository.dart';
import 'package:nurse/shared/repositories/vaccination/application_repository.dart';

class VaccinationEntryController {
  VaccinationEntryController([
    ApplicationRepository? applicationRepository,
  ]) : _repository = applicationRepository ?? DatabaseApplicationRepository() {
    applicationFormController = ApplicationFormController(_repository);
  }

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final int formsCount = 5;
  int _formIndex = 0;
  int get formIndex => _formIndex;
  bool get isLastForm => _formIndex == (formsCount - 1);

  final ApplicationRepository _repository;

  final campaignFormController = CampaignFormController();
  final applierFormController = ApplierFormController();
  final vaccineFormController = VaccineFormController();
  final patientFormController = PatientFormController();
  late final ApplicationFormController applicationFormController;

  FormController getCurrentFormController() {
    switch (formIndex) {
      case 0:
        return campaignFormController;
      case 1:
        return applierFormController;
      case 2:
        return vaccineFormController;
      case 3:
        return patientFormController;
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
    final currentFormController = getCurrentFormController();
    final wasSubmited = submitIfFormValid(currentFormController);

    if (wasSubmited && nextFormIsApplicationForm) {
      applicationFormController.setApplicationDependencies(
        applierFormController.applier!,
        vaccineFormController.vaccineBatch!,
        patientFormController.patient!,
        campaignFormController.campaign!,
      );
    }

    if (wasSubmited) updateFormIndex(_formIndex + 1);
  }

  bool submitIfFormValid(FormController formController) {
    final submitted = formController.submitForm(formController.formKey);

    return submitted;
  }

  bool get nextFormIsApplicationForm => formIndex + 1 == 4;

  Future<bool> saveVaccination(BuildContext context) async {
    final exists = await verifyIfApplicationExists();

    if (exists) return false;

    await save(applicationFormController.application!);

    return cleanAllForms();
  }

  Future<bool> verifyIfApplicationExists() async {
    if (applicationFormController.application != null &&
        applicationFormController.application!.patient.id != null) {
      return await _repository.exists(applicationFormController.application!);
    } else {
      return false;
    }
  }

  Future<int> save(Application application) async {
    return await _repository.createApplication(application);
  }

  bool cleanAllForms() {
    campaignFormController.clearAllInfo();
    applierFormController.clearAllInfo();
    vaccineFormController.clearAllInfo();
    patientFormController.clearAllInfo();
    applicationFormController.clearAllInfo();

    return true;
  }
}
