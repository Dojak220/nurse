import 'package:flutter/material.dart';

class VaccinationEntryController {
  final _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  late final String patientCNSValue;
  late final String batchValue;
  late final String doseValue;
  late final String applierCNSValue;
  late final DateTime? dateValue;
  late final String groupValue;

  VaccinationEntryController();

  void submitForm() {
    formKey.currentState!.save();
  }
}
