import 'package:flutter/material.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_patient_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_applier_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';
import 'package:nurse/shared/repositories/patient/patient_repository.dart';
import 'package:nurse/shared/repositories/vaccination/application_repository.dart';
import 'package:nurse/shared/repositories/vaccination/applier_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_repository.dart';

class DatabaseApplicationRepository extends DatabaseInterface
    with ChangeNotifier
    implements ApplicationRepository {
  static const String TABLE = "Application";

  final VaccineRepository _vaccineRepo;
  final PatientRepository _patientRepo;
  final CampaignRepository _campaignRepo;
  final ApplierRepository _applierRepo;

  DatabaseApplicationRepository({
    DatabaseManager? dbManager,
    VaccineRepository? vaccineRepo,
    PatientRepository? patientRepo,
    CampaignRepository? campaignRepo,
    ApplierRepository? applierRepo,
  })  : _vaccineRepo = vaccineRepo ?? DatabaseVaccineRepository(),
        _patientRepo = patientRepo ?? DatabasePatientRepository(),
        _campaignRepo = campaignRepo ?? DatabaseCampaignRepository(),
        _applierRepo = applierRepo ?? DatabaseApplierRepository(),
        super(TABLE, dbManager);

  @override
  Future<int> createApplication(Application application) async {
    final map = application.toMap();

    map['vaccine'] = await _vaccineRepo
        .getVaccineBySipniCode(application.vaccine.sipniCode)
        .then((vaccine) => vaccine.id!);
    map['patient'] = await _patientRepo
        .getPatientByCns(application.patient.cns)
        .then((patient) => patient.id!);
    map['campaign'] = await _campaignRepo
        .getCampaignByTitle(application.campaign.title)
        .then((campaign) => campaign.id!);
    map['applier'] = await _applierRepo
        .getApplierByCns(application.applier.cns)
        .then((applier) => applier.id!);

    final int result = await create(map);

    return result;
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

      final applier = await _getApplier(applicationMap["applier"]);
      final vaccine = await _getVaccine(applicationMap["vaccine"]);
      final patient = await _getPatient(applicationMap["patient"]);
      final campaign = await _getCampaign(applicationMap["campaign"]);

      applicationMap["applier"] = applier.toMap();
      applicationMap["vaccine"] = vaccine.toMap();
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

  Future<Vaccine> _getVaccine(int id) async {
    final vaccine = await _vaccineRepo.getVaccineById(id);

    return vaccine;
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
  Future<List<Application>> getApplications() async {
    try {
      final applicationMaps = await getAll();
      final appliers = await _getAppliers();
      final vaccines = await _getVaccines();
      final patients = await _getPatients();
      final campaigns = await _getCampaigns();

      applicationMaps.forEach((a) {
        final applier = appliers.firstWhere((applier) {
          return applier.id == a["applier"];
        });

        final vaccine = vaccines.firstWhere((vaccine) {
          return vaccine.id == a["vaccine"];
        });

        final patient = patients.firstWhere((p) {
          return p.id == a["patient"];
        });

        final campaign = campaigns.firstWhere((e) {
          return e.id == a["campaign"];
        });

        a["applier"] = applier.toMap();
        a["vaccine"] = vaccine.toMap();
        a["patient"] = patient.toMap();
        a["campaign"] = campaign.toMap();
      });

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

  Future<List<Vaccine>> _getVaccines() async {
    final vaccines = await _vaccineRepo.getVaccines();

    return vaccines;
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
