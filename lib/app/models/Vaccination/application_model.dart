import 'package:nurse/app/models/Infra/campaign_model.dart';
import 'package:nurse/app/models/Patient/patient_model.dart';
import 'package:nurse/app/models/Vaccination/applier_model.dart';
import 'package:nurse/app/models/Vaccination/vaccine_batch_model.dart';

class ApplicationModel {
  final int id;
  final Patient patient;
  final DateTime applicationDate;
  final ApplierModel applier;
  final VaccineBatchModel vaccineBatch;
  final VaccineDose vaccineDose;
  final CampaignModel campaign;
  final DateTime dueDate;

  ApplicationModel(
    this.id,
    this.patient,
    this.applicationDate,
    this.applier,
    this.vaccineBatch,
    this.vaccineDose,
    this.campaign,
    this.dueDate,
  );
}

enum VaccineDose { D1, D2, DA, REF }
