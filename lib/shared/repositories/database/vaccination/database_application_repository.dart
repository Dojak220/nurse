import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';
import 'package:nurse/shared/repositories/patient/patient_repository.dart';
import 'package:nurse/shared/repositories/vaccination/application_repository.dart';
import 'package:nurse/shared/repositories/vaccination/applier_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_repository.dart';

class DatabaseApplicationRepository extends DatabaseInterface
    implements ApplicationRepository {
  static const String TABLE = "Application";
  final VaccineRepository vaccineRepo;
  final PatientRepository patientRepo;
  final CampaignRepository campaignRepo;
  final ApplierRepository applierRepo;

  DatabaseApplicationRepository({
    DatabaseManager? dbManager,
    required this.vaccineRepo,
    required this.patientRepo,
    required this.campaignRepo,
    required this.applierRepo,
  }) : super(TABLE, dbManager);

  @override
  Future<int> createApplication(Application applier) async {
    final int result = await create(applier.toMap());

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
      final applicationMap = await get(id);

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
    final applier = await applierRepo.getApplierById(id);

    return applier;
  }

  Future<Vaccine> _getVaccine(int id) async {
    final vaccine = await vaccineRepo.getVaccineById(id);

    return vaccine;
  }

  Future<Patient> _getPatient(int id) async {
    final patient = await patientRepo.getPatientById(id);

    return patient;
  }

  Future<Campaign> _getCampaign(int id) async {
    final campaign = await campaignRepo.getCampaignById(id);

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
    final appliers = await applierRepo.getAppliers();

    return appliers;
  }

  Future<List<Vaccine>> _getVaccines() async {
    final vaccines = await vaccineRepo.getVaccines();

    return vaccines;
  }

  Future<List<Patient>> _getPatients() async {
    final patients = await patientRepo.getPatients();

    return patients;
  }

  Future<List<Campaign>> _getCampaigns() async {
    final campaigns = await campaignRepo.getCampaigns();

    return campaigns;
  }

  @override
  Future<int> updateApplication(Application applier) async {
    final int updatedCount = await update(applier.toMap());

    return updatedCount;
  }
}
