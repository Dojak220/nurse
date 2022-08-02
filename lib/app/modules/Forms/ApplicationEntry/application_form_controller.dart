import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/repositories/vaccination/application_repository.dart';

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
    Campaign campaign,
  ) {
    this.applier = applier;
    this.vaccineBatch = vaccineBatch;
    this.patient = patient;
    this.campaign = campaign;

    applierName.text = applier.person.name;
    vaccineBatchNumber.text = vaccineBatch.vaccine.toString();
    patientName.text = patient.person.name;
    campaignTitle.text = campaign.title;
  }

  Future<void> selectDate(BuildContext context) async {
    final newSelectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newSelectedDate != null) {
      selectedDate = newSelectedDate;
      date
        ..text = DateFormat("dd/MM/yyyy").format(selectedDate!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: date.text.length, affinity: TextAffinity.upstream));
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

  @override
  void clearAllInfo() {
    selectedDose = null;
    selectedDate = null;
    notifyListeners();
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();
  }
}
