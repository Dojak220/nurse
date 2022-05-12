import 'package:mobx/mobx.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_patient_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_person_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_application_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_applier_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_batch_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart';
import 'package:nurse/shared/repositories/vaccination/application_repository.dart';
import 'package:nurse/shared/utils/helper.dart';

class HomeController {
  final ApplicationRepository applicationRepository;

  final applications = ObservableList<Application>.of(
    List<Application>.empty(growable: true),
  );

  late final fetchApplications = Action(_fetchApplications);

  HomeController()
      : applicationRepository = DatabaseApplicationRepository(
          applierRepo: DatabaseApplierRepository(
            establishmentRepo: DatabaseEstablishmentRepository(
              localityRepo: DatabaseLocalityRepository(),
            ),
            personRepo: DatabasePersonRepository(
              localityRepo: DatabaseLocalityRepository(),
            ),
          ),
          campaignRepo: DatabaseCampaignRepository(),
          patientRepo: DatabasePatientRepository(
            personRepo: DatabasePersonRepository(
              localityRepo: DatabaseLocalityRepository(),
            ),
            categoryRepo: DatabasePriorityCategoryRepository(
              groupRepo: DatabasePriorityGroupRepository(),
            ),
          ),
          vaccineRepo: DatabaseVaccineRepository(
            vaccineBatchRepo: DatabaseVaccineBatchRepository(),
          ),
        ) {
    _fetchApplications(applicationRepository);
  }

  Future<List<Application>> _fetchApplications(ApplicationRepository aR) async {
    final result = await aR.getApplications();
    applications.addAll(result);

    return applications;
  }

  Map<String, int> applicationCount() {
    final applicationCountMap = Map<String, int>.of({
      "dia": Helper.applicationsForPeriod(applications, Period.day),
      "semana": Helper.applicationsForPeriod(applications, Period.week),
      "mês": Helper.applicationsForPeriod(applications, Period.month),
    });

    return applicationCountMap;
  }
}
