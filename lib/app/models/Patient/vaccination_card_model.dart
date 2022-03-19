import 'package:nurse/app/models/Patient/patient_model.dart';
import 'package:nurse/app/models/Vaccination/application_model.dart';

class VaccinationCardModel {
  final int id;
  final Patient patient;
  final ApplicationModel application;

  VaccinationCardModel(
    this.id,
    this.patient,
    this.application,
  );
}
