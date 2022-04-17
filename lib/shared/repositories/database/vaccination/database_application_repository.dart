import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_patient_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_applier_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_batch_repository.dart';
import 'package:nurse/shared/repositories/vaccination/application_repository.dart';

class DatabaseApplicationRepository extends DatabaseInterface
    implements ApplicationRepository {
  static const String TABLE = "Application";
  final DatabaseManager dbManager;

  DatabaseApplicationRepository(this.dbManager) : super(dbManager, TABLE);

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
      final applierMap = await get(id);

      final applier = await _getApplier(applierMap["applier"]);
      final patient = await _getPatient(applierMap["patient"]);
      final campaign = await _getCampaign(
        applierMap["campaign"],
      );
      final vaccineBatch = await _getVaccineBatch(applierMap["vaccineBatch"]);

      applierMap["applier"] = applier.toMap();
      applierMap["patient"] = patient.toMap();
      applierMap["campaign"] = campaign.toMap();
      applierMap["vaccineBatch"] = vaccineBatch.toMap();

      final application = Application.fromMap(applierMap);

      return application;
    } catch (e) {
      rethrow;
    }
  }

  Future<Applier> _getApplier(int id) async {
    final dbRepo = DatabaseApplierRepository(dbManager);
    final applier = await dbRepo.getApplierById(id);

    return applier;
  }

  Future<Patient> _getPatient(int id) async {
    final dbRepo = DatabasePatientRepository(dbManager);
    final patient = await dbRepo.getPatientById(id);

    return patient;
  }

  Future<Campaign> _getCampaign(int id) async {
    final dbRepo = DatabaseCampaignRepository(dbManager);
    final campaign = await dbRepo.getCampaignById(id);

    return campaign;
  }

  Future<VaccineBatch> _getVaccineBatch(int id) async {
    final dbRepo = DatabaseVaccineBatchRepository(dbManager);
    final vaccineBatch = await dbRepo.getVaccineBatchById(id);

    return vaccineBatch;
  }

  @override
  Future<List<Application>> getApplications() async {
    try {
      final applicationMaps = await getAll();
      final appliers = await _getAppliers();
      final patients = await _getPatients();
      final campaigns = await _getCampaigns();
      final vaccineBatches = await _getVaccineBatches();

      applicationMaps.forEach((a) {
        final applier = appliers.firstWhere((applier) {
          return applier.id == a["applier"];
        });

        final patient = patients.firstWhere((p) {
          return p.id == a["patient"];
        });

        final campaign = campaigns.firstWhere((e) {
          return e.id == a["campaign"];
        });

        final vaccineBatch = vaccineBatches.firstWhere((v) {
          return v.id == a["vaccineBatch"];
        });

        a["applier"] = applier;
        a["patient"] = patient;
        a["campaign"] = campaign;
        a["vaccineBatch"] = vaccineBatch;
      });

      final applications = applicationMaps.map((application) {
        return Application.fromMap(application);
      }).toList();

      return applications;
    } catch (e) {
      return List<Application>.empty();
    }
  }

  Future<List<Applier>> _getAppliers() async {
    final dbRepo = DatabaseApplierRepository(dbManager);
    final appliers = await dbRepo.getAppliers();

    return appliers;
  }

  Future<List<Patient>> _getPatients() async {
    final dbRepo = DatabasePatientRepository(dbManager);
    final patients = await dbRepo.getPatients();

    return patients;
  }

  Future<List<Campaign>> _getCampaigns() async {
    final dbRepo = DatabaseCampaignRepository(dbManager);
    final campaigns = await dbRepo.getCampaigns();

    return campaigns;
  }

  Future<List<VaccineBatch>> _getVaccineBatches() async {
    final dbRepo = DatabaseVaccineBatchRepository(dbManager);
    final vaccineBatches = await dbRepo.getVaccineBatches();

    return vaccineBatches;
  }

  @override
  Future<int> updateApplication(Application applier) async {
    final int updatedCount = await update(applier.toMap());

    return updatedCount;
  }
}
