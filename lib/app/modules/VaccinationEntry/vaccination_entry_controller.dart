import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field%20.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_application_repository.dart';
import 'package:nurse/shared/utils/validator.dart';

class VaccinationEntryController {
  final _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  late final String patientCNSValue;
  late final String batchValue;
  late final String doseValue;
  late final String applierCNSValue;
  late final String dateValue;
  late final String groupValue;

  late final List<Widget> fields;

  VaccinationEntryController() {
    fields = [
      CustomTextFormField(
        icon: Icon(Icons.badge),
        label: FormLabels.cnsPatient,
        validatorType: ValidatorType.CNS,
        onSaved: (value) => {patientCNSValue = value!},
      ),
      CustomTextFormField(
        icon: Icon(Icons.local_shipping),
        label: FormLabels.batchNumber,
        validatorType: ValidatorType.NumericalString,
        onSaved: (value) => {batchValue = value!},
      ),
      CustomDropdownButtonFormField(
        icon: Icon(Icons.vaccines),
        label: FormLabels.dose,
        items: VaccineDose.values,
        onChanged: (VaccineDose? value) => {doseValue = value!.name},
      ),
      CustomTextFormField(
        icon: Icon(Icons.badge),
        label: FormLabels.cnsApplier,
        validatorType: ValidatorType.CNS,
        onSaved: (value) => {applierCNSValue = value!},
      ),
      CustomTextFormField(
        icon: Icon(Icons.calendar_month),
        label: FormLabels.date,
        validatorType: ValidatorType.PastDate,
        onSaved: (value) => {dateValue = value!},
      ),
      CustomTextFormField(
        icon: Icon(Icons.group),
        label: FormLabels.group,
        validatorType: ValidatorType.Name,
        onSaved: (value) => {groupValue = value!},
      ),
      CustomDropdownButtonFormField(
        icon: Icon(Icons.pregnant_woman),
        label: FormLabels.maternalCondition,
        items: MaternalCondition.values,
        onChanged: (MaternalCondition? value) => {doseValue = value!.name},
      ),
    ];
  }

  void submitForm() {
    formKey.currentState!.save();
    final repository = DatabaseApplicationRepository();
  }
}
