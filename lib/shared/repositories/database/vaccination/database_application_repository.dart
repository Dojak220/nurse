import 'package:flutter/material.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_patient_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_applier_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_batch_repository.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';
import 'package:nurse/shared/repositories/patient/patient_repository.dart';
import 'package:nurse/shared/repositories/vaccination/application_repository.dart';
import 'package:nurse/shared/repositories/vaccination/applier_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_batch_repository.dart';

class DatabaseApplicationRepository extends DatabaseInterface
    with ChangeNotifier
    implements ApplicationRepository {
  // ignore: constant_identifier_names
  static const String TABLE = "Application";

  final VaccineBatchRepository _vaccineBatchRepo;
  final PatientRepository _patientRepo;
  final CampaignRepository _campaignRepo;
  final ApplierRepository _applierRepo;

  DatabaseApplicationRepository({
    DatabaseManager? dbManager,
    VaccineBatchRepository? vaccineBatchRepo,
    PatientRepository? patientRepo,
    CampaignRepository? campaignRepo,
    ApplierRepository? applierRepo,
  })  : _vaccineBatchRepo =
            vaccineBatchRepo ?? DatabaseVaccineBatchRepository(),
        _patientRepo = patientRepo ?? DatabasePatientRepository(),
        _campaignRepo = campaignRepo ?? DatabaseCampaignRepository(),
        _applierRepo = applierRepo ?? DatabaseApplierRepository(),
        super(TABLE, dbManager);

  @override
  Future<int> createApplication(Application application) async {
    final map = application.toMap();

    map['vaccine_batch'] = await _vaccineBatchRepo
        .getVaccineBatchByNumber(application.vaccineBatch.number)
        .then((vaccine) => vaccine.id!);
    map["patient"] = await _getOrCreatePatient(application);
    map['campaign'] = await _campaignRepo
        .getCampaignByTitle(application.campaign.title)
        .then((campaign) => campaign.id!);
    map['applier'] = await _applierRepo
        .getApplierByCns(application.applier.cns)
        .then((applier) => applier.id!);

    final int result = await create(map);

    return result;
  }

  Future<int> _getOrCreatePatient(
    Application application,
  ) async {
    int patientId;
    try {
      patientId = await _patientRepo
          .getPatientByCns(application.patient.cns)
          .then((patient) => patient.id!);
    } on StateError catch (e) {
      if (e.message.contains("No element")) {
        patientId = await _patientRepo.createPatient(application.patient);
      } else {
        rethrow;
      }
    }

    return patientId;
  }

  @override
  Future<int> deleteApplication(int id) async {
    final int deletedCount = await delete(id);

    return deletedCount;
  }

  @override
  Future<Application> getApplicationById(int id) async {
    try {
      final applicationMap = await getById(id);

      final applier = await _getApplier(applicationMap["applier"] as int);
      final vaccineBatch =
          await _getVaccineBatch(applicationMap["vaccine_batch"] as int);
      final patient = await _getPatient(applicationMap["patient"] as int);
      final campaign = await _getCampaign(applicationMap["campaign"] as int);

      applicationMap["applier"] = applier.toMap();
      applicationMap["vaccine_batch"] = vaccineBatch.toMap();
      applicationMap["patient"] = patient.toMap();
      applicationMap["campaign"] = campaign.toMap();

      final application = Application.fromMap(applicationMap);

      return application;
    } catch (e) {
      rethrow;
    }
  }

  Future<Applier> _getApplier(int id) async {
    final applier = await _applierRepo.getApplierById(id);

    return applier;
  }

  Future<VaccineBatch> _getVaccineBatch(int id) async {
    final vaccineBatch = await _vaccineBatchRepo.getVaccineBatchById(id);

    return vaccineBatch;
  }

  Future<Patient> _getPatient(int id) async {
    final patient = await _patientRepo.getPatientById(id);

    return patient;
  }

  Future<Campaign> _getCampaign(int id) async {
    final campaign = await _campaignRepo.getCampaignById(id);

    return campaign;
  }

  @override
  Future<bool> exists(Application application) async {
    try {
      final applicationExists = await get(
        objs: [application.patient.id, application.dose.name],
        where: "patient = ? and dose = ?",
      ).then((applications) => applications.isNotEmpty);

      return applicationExists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<List<Application>> getApplications() async {
    try {
      final applicationMaps = await getAll();
      final appliers = await _getAppliers();
      final vaccineBatches = await _getVaccineBatches();
      final patients = await _getPatients();
      final campaigns = await _getCampaigns();

      for (final applicationMap in applicationMaps) {
        final applier = appliers.firstWhere((applier) {
          return applier.id == applicationMap["applier"];
        });

        final vaccineBatch = vaccineBatches.firstWhere((vaccineBatch) {
          return vaccineBatch.id == applicationMap["vaccine_batch"];
        });

        final patient = patients.firstWhere((p) {
          return p.id == applicationMap["patient"];
        });

        final campaign = campaigns.firstWhere((e) {
          return e.id == applicationMap["campaign"];
        });

        applicationMap["applier"] = applier.toMap();
        applicationMap["vaccine_batch"] = vaccineBatch.toMap();
        applicationMap["patient"] = patient.toMap();
        applicationMap["campaign"] = campaign.toMap();
      }

      final applications = applicationMaps.map((application) {
        return Application.fromMap(application);
      }).toList();

      return applications;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Applier>> _getAppliers() async {
    final appliers = await _applierRepo.getAppliers();

    return appliers;
  }

  Future<List<VaccineBatch>> _getVaccineBatches() async {
    final vaccineBatches = await _vaccineBatchRepo.getVaccineBatches();

    return vaccineBatches;
  }

  Future<List<Patient>> _getPatients() async {
    final patients = await _patientRepo.getPatients();

    return patients;
  }

  Future<List<Campaign>> _getCampaigns() async {
    final campaigns = await _campaignRepo.getCampaigns();

    return campaigns;
  }

  @override
  Future<int> updateApplication(Application applier) async {
    final int updatedCount = await update(applier.toMap());

    return updatedCount;
  }
}
