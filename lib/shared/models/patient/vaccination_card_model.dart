import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';

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
