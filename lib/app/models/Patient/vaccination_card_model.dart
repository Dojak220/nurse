import 'package:nurse/app/models/patient/patient_model.dart';
import 'package:nurse/app/models/vaccination/application_model.dart';

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
