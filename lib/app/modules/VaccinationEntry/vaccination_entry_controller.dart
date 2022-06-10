import 'package:flutter/material.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_application_repository.dart';

class VaccinationEntryController {
  final _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  late final String patientCNSValue;
  late final String batchValue;
  late final String doseValue;
  late final String applierCNSValue;
  late final String dateValue;
  late final String groupValue;


  VaccinationEntryController();

  void submitForm() {
    formKey.currentState!.save();
    final repository = DatabaseApplicationRepository();
  }
}
