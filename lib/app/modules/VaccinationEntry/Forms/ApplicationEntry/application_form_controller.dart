import "package:flutter/material.dart";
import "package:nurse/app/utils/date_picker.dart";
import "package:nurse/app/utils/form_controller.dart";
import "package:nurse/shared/models/infra/campaign_model.dart";
import "package:nurse/shared/models/patient/patient_model.dart";
import "package:nurse/shared/models/vaccination/application_model.dart";
import "package:nurse/shared/models/vaccination/applier_model.dart";
import "package:nurse/shared/models/vaccination/vaccine_batch_model.dart";
import "package:nurse/shared/repositories/vaccination/application_repository.dart";

class ApplicationFormController extends FormController {
  Applier? applier;
  VaccineBatch? vaccineBatch;
  Patient? patient;
  Campaign? campaign;
  String? selectedDose;
  DateTime? selectedDate;

  TextEditingController applierName = TextEditingController();
  TextEditingController vaccineBatchNumber = TextEditingController();
  TextEditingController patientName = TextEditingController();
  TextEditingController campaignTitle = TextEditingController();
  TextEditingController date = TextEditingController();

  ApplicationFormController([
    ApplicationRepository? applicationRepository,
  ]);

  void setApplicationDependencies(
    Applier applier,
    VaccineBatch vaccineBatch,
    Patient patient,
    Campaign? campaign,
  ) {
    this.applier = applier;
    this.vaccineBatch = vaccineBatch;
    this.patient = patient;
    this.campaign = campaign;

    applierName.text = applier.person.name;
    vaccineBatchNumber.text = vaccineBatch.vaccine.toString();
    patientName.text = patient.person.name;
    campaignTitle.text = campaign?.title ?? "";
  }

  Future<void> selectDate(BuildContext context) async {
    final newSelectedDate = await DatePicker.getNewDate(context, selectedDate);

    if (newSelectedDate != null) {
      selectedDate = newSelectedDate;
      date
        ..text = DatePicker.formatDateDDMMYYYY(selectedDate!)
        ..selection = TextSelection.fromPosition(
          TextPosition(
            offset: date.text.length,
            affinity: TextAffinity.upstream,
          ),
        );
    }
  }

  Application? get application {
    if (_allFieldsFulfilled) {
      return Application(
        applier: applier!,
        vaccineBatch: vaccineBatch!,
        patient: patient!,
        campaign: campaign!,
        dose: VaccineDoseExtension.fromString(selectedDose!),
        applicationDate: selectedDate!,
      );
    }
    return null;
  }

  bool get _allFieldsFulfilled {
    return applier != null &&
        vaccineBatch != null &&
        patient != null &&
        campaign != null &&
        selectedDose != null &&
        selectedDate != null;
  }

  void setApplication(Application application) {
    setApplicationDependencies(
      application.applier,
      application.vaccineBatch,
      application.patient,
      application.campaign,
    );

    selectedDose = application.dose.toString();
    selectedDate = application.applicationDate;
    date.text = DatePicker.formatDateDDMMYYYY(selectedDate!);
  }

  @override
  void clearAllInfo() {
    selectedDose = null;
    selectedDate = null;

    notifyListeners();
  }

  @override
  void dispose() {
    applierName.dispose();
    vaccineBatchNumber.dispose();
    patientName.dispose();
    campaignTitle.dispose();
    date.dispose();
  }
}
