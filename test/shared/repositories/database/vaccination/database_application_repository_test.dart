import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
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
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_application_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabaseApplicationRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();

  final repository = DatabaseApplicationRepository(dbManager);

  setUp(() {
    when(dbManager.db).thenReturn(db);
  });

  testCreateApplication(db, repository);
  testDeleteApplication(db, repository);
  testGetApplication(db, repository);
  testGetApplications(db, repository);
  testUpdateApplication(db, repository);
}

void testCreateApplication(
  MockDatabase db,
  DatabaseApplicationRepository repository,
) {
  group("createApplication function:", () {
    final int validApplicationId = 1;
    final int validPatientId = 1;
    final int validVaccineId = 1;
    final int validApplierId = 1;

    final validLocality = Locality(
      id: 1,
      name: "Locality Name",
      city: "City Name",
      state: "State Name",
      ibgeCode: "1234567",
    );

    final validApplier = Applier(
      id: validApplierId,
      cns: "279197866950004",
      person: Person(
        id: 1,
        cpf: "82675387630",
        name: "Name Middlename Lastname",
        birthDate: DateTime(2000),
        locality: validLocality,
      ),
      establishment: Establishment(
        id: 1,
        cnes: "1234567",
        name: "Establishment Name",
        locality: validLocality,
      ),
    );

    final validPatient = Patient(
      id: validPatientId,
      cns: "748477761910001",
      maternalCondition: MaternalCondition.GESTANTE,
      priorityCategory: PriorityCategory(
        id: 1,
        priorityGroup: PriorityGroup(
          id: 1,
          groupCode: "Pessoas com mais de 60 anos",
        ),
        categoryCode: "Pessoas idosas",
        name: "Idosos",
        description: "Categoria para pessoas idosas",
      ),
      person: Person(
        id: 1,
        cpf: "67732120817",
        name: "Name Middlename Lastname",
        birthDate: DateTime(2000),
        locality: validLocality,
      ),
    );

    final validCampaign = Campaign(
      id: 1,
      title: "Campaign Title",
      description: "Campaign Description",
      startDate: DateTime(2022),
    );

    final validVaccine = Vaccine(
      id: validVaccineId,
      sipniCode: "123456",
      name: "Vaccine Name",
      laboratory: "Laboratory Name",
      vaccineBatch: VaccineBatch(
        id: 1,
        batchNo: "01234",
        quantity: 10,
      ),
    );

    final validVaccineBatch = VaccineBatch(
      id: 1,
      batchNo: "123456",
      quantity: 20,
    );

    final expectedApplication = Application(
      id: validApplicationId,
      patient: validPatient,
      vaccine: validVaccine,
      applicationDate: DateTime(2022, 3, 4),
      applier: validApplier,
      vaccineBatch: validVaccineBatch,
      vaccineDose: VaccineDose.D1,
      campaign: validCampaign,
      dueDate: DateTime(2022, 4),
    );

    group('try to create a valid application', () {
      setUp(() {
        when(db.insert(DatabaseApplicationRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new application entry and return its id", () async {
        final newId = await repository.createApplication(expectedApplication);

        expect(newId, 1);
      });
    });
  });
}

void testDeleteApplication(
  MockDatabase db,
  DatabaseApplicationRepository repository,
) {
  group("deleteApplication function:", () {
    final int validApplicationId = 1;
    final int invalidApplicationId = 2;

    group('try to delete valid application', () {
      setUp(() {
        when(db.delete(
          DatabaseApplicationRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validApplicationId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete an application entry and returns 1", () async {
        final deletedCount =
            await repository.deleteApplication(validApplicationId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid application', () {
      setUp(() {
        when(db.delete(
          DatabaseApplicationRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [invalidApplicationId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesnt exist", () async {
        final deletedCount =
            await repository.deleteApplication(invalidApplicationId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetApplication(
  MockDatabase db,
  DatabaseApplicationRepository repository,
) {
  group("getApplication function:", () {
    final int validApplicationId = 1;
    final int validApplierId = 1;
    final int validPatientId = 1;
    final int validCampaignId = 1;
    final int validVaccineId = 1;
    final int validVaccineBatchId = 1;

    final validLocalityId = 1;
    final validLocality = Locality(
      id: validLocalityId,
      name: "Locality Name",
      city: "City Name",
      state: "State Name",
      ibgeCode: "1234567",
    );

    final validEstablishmentId = 1;
    final validEstablishment = Establishment(
      id: validEstablishmentId,
      cnes: "1234567",
      name: "Establishment Name",
      locality: validLocality,
    );

    final validPersonApplierId = 1;
    final validPersonApplier = Person(
      id: validPersonApplierId,
      cpf: "98675584806",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: validLocality,
    );

    final validApplier = Applier(
      id: validApplierId,
      cns: "279197866950004",
      person: validPersonApplier,
      establishment: validEstablishment,
    );

    final validPersonPatientId = 2;
    final validPersonPatient = Person(
      id: validPersonPatientId,
      cpf: "67732120817",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: validLocality,
    );

    final validPriorityGroupId = 1;
    final validPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      groupCode: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    final validPriorityCategoryId = 1;
    final validPriorityCategory = PriorityCategory(
      id: validPriorityCategoryId,
      priorityGroup: validPriorityGroup,
      categoryCode: "Pessoas idosas",
      name: "Idosos",
      description: "Categoria para pessoas idosas",
    );

    final validPatient = Patient(
      id: validPatientId,
      cns: "748477761910001",
      maternalCondition: MaternalCondition.GESTANTE,
      priorityCategory: validPriorityCategory,
      person: validPersonPatient,
    );

    final validCampaign = Campaign(
      id: validCampaignId,
      title: "Campaign Title",
      description: "Campaign Description",
      startDate: DateTime(2022),
    );

    final validVaccineBatch = VaccineBatch(
      id: validVaccineBatchId,
      batchNo: "123456",
      quantity: 20,
    );

    final validVaccine = Vaccine(
      id: validVaccineId,
      sipniCode: "123456",
      name: "Vaccine Name",
      laboratory: "Laboratory Name",
      vaccineBatch: validVaccineBatch,
    );

    final expectedApplication = Application(
      id: validApplicationId,
      patient: validPatient,
      vaccine: validVaccine,
      applicationDate: DateTime(2022, 3, 4),
      applier: validApplier,
      vaccineBatch: validVaccineBatch,
      vaccineDose: VaccineDose.D1,
      campaign: validCampaign,
      dueDate: DateTime(2022, 4),
    );

    group('try to get valid application', () {
      setUp(() {
        when(db.query(
          DatabaseApplicationRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validApplicationId],
        )).thenAnswer(
          (_) => Future.value([
            {
              'id': expectedApplication.id,
              'patient': expectedApplication.patient.id,
              'vaccine': expectedApplication.vaccine.id,
              'applicationDate':
                  expectedApplication.applicationDate.millisecondsSinceEpoch,
              'applier': expectedApplication.applier.id,
              'vaccineBatch': expectedApplication.vaccineBatch.id,
              'vaccineDose': expectedApplication.vaccineDose.name,
              'campaign': expectedApplication.campaign.id,
              'dueDate': expectedApplication.dueDate.millisecondsSinceEpoch,
            }
          ]),
        );

        when(db.query(
          DatabaseLocalityRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validLocalityId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validLocality.id,
              "name": validLocality.name,
              "city": validLocality.city,
              "state": validLocality.state,
              "ibgeCode": validLocality.ibgeCode,
            }
          ]),
        );

        when(db.query(
          DatabasePersonRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPersonApplierId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validPersonApplier.id,
              "cpf": validPersonApplier.cpf,
              "name": validPersonApplier.name,
              "birthDate": validPersonApplier.birthDate.millisecondsSinceEpoch,
              "locality": validPersonApplier.locality.id,
            }
          ]),
        );
        when(db.query(
          DatabaseEstablishmentRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validEstablishmentId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validEstablishment.id,
              "cnes": validEstablishment.cnes,
              "name": validEstablishment.name,
              "locality": validEstablishment.locality.id,
            }
          ]),
        );
        when(db.query(
          DatabaseApplierRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validApplierId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validApplier.id,
              "cns": validApplier.cns,
              "person": validApplier.person.id,
              "establishment": validApplier.establishment.id,
            }
          ]),
        );

        when(db.query(
          DatabasePersonRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPersonPatientId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validPersonPatient.id,
              "cpf": validPersonPatient.cpf,
              "name": validPersonPatient.name,
              "birthDate": validPersonPatient.birthDate.millisecondsSinceEpoch,
              "locality": validPersonPatient.locality.id,
            }
          ]),
        );

        when(db.query(
          DatabasePriorityGroupRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPriorityGroupId],
        )).thenAnswer(
          (_) => Future.value([
            {
              'id': validPriorityGroup.id,
              'groupCode': validPriorityGroup.groupCode,
              'name': validPriorityGroup.name,
              'description': validPriorityGroup.description,
            }
          ]),
        );

        when(db.query(
          DatabasePriorityCategoryRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPriorityCategoryId],
        )).thenAnswer(
          (_) => Future.value([
            {
              'id': validPriorityCategory.id,
              'priorityGroup': validPriorityCategory.priorityGroup.id,
              'categoryCode': validPriorityCategory.categoryCode,
              'name': validPriorityCategory.name,
              'description': validPriorityCategory.description,
            }
          ]),
        );

        when(db.query(
          DatabasePatientRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPatientId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validPatient.id,
              "cns": validPatient.cns,
              "maternalCondition": validPatient.maternalCondition.name,
              "priorityCategory": validPatient.priorityCategory.id,
              "person": validPatient.person.id,
            }
          ]),
        );
      });

      when(db.query(
        DatabaseCampaignRepository.TABLE,
        where: anyNamed("where"),
        whereArgs: [validCampaignId],
      )).thenAnswer(
        (_) => Future.value([
          {
            "id": validCampaign.id,
            "title": validCampaign.title,
            "description": validCampaign.description,
            "startDate": validCampaign.startDate.millisecondsSinceEpoch,
            "endDate": validCampaign.endDate.millisecondsSinceEpoch,
          }
        ]),
      );

      when(db.query(
        DatabaseVaccineRepository.TABLE,
        where: anyNamed("where"),
        whereArgs: [validVaccineId],
      )).thenAnswer(
        (_) => Future.value([
          {
            "id": validVaccine.id,
            "sipniCode": validVaccine.sipniCode,
            "name": validVaccine.name,
            "laboratory": validVaccine.laboratory,
            "vaccineBatch": validVaccine.vaccineBatch.id,
          }
        ]),
      );

      when(db.query(
        DatabaseVaccineBatchRepository.TABLE,
        where: anyNamed("where"),
        whereArgs: [validVaccineBatchId],
      )).thenAnswer(
        (_) => Future.value([
          {
            "id": validVaccineBatch.id,
            "batchNo": validVaccineBatch.batchNo,
            "quantity": validVaccineBatch.quantity,
          }
        ]),
      );

      test("should get a application entry by its id", () async {
        final actualApplication =
            await repository.getApplicationById(validApplicationId);

        expect(actualApplication, isA<Application>());
        expect(actualApplication, expectedApplication);
      });
    });

    group('try to get an invalid application', () {
      setUp(() {
        when(db.query(
          DatabaseApplicationRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [2],
        )).thenAnswer((_) => Future.value([]));
      });

      test("should throw exception if id doesn't exist", () async {
        expect(
          () async => await repository.getApplicationById(2),
          throwsStateError,
        );
      });
    });
  });
}

void testGetApplications(
  MockDatabase db,
  DatabaseApplicationRepository repository,
) {
  group("getApplications function:", () {
    final int validApplicationId = 1;
    final int validApplierId = 1;
    final int validPatientId = 1;
    final int validCampaignId = 1;
    final int validVaccineBatchId = 1;

    final validLocalityId = 1;
    final validLocality = Locality(
      id: validLocalityId,
      name: "Locality Name",
      city: "City Name",
      state: "State Name",
      ibgeCode: "1234567",
    );

    final validEstablishmentId = 1;
    final validEstablishment = Establishment(
      id: validEstablishmentId,
      cnes: "1234567",
      name: "Establishment Name",
      locality: validLocality,
    );

    final validPersonApplierId = 1;
    final validPersonApplier = Person(
      id: validPersonApplierId,
      cpf: "98675584806",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: validLocality,
    );

    final validApplier = Applier(
      id: validApplierId,
      cns: "279197866950004",
      person: validPersonApplier,
      establishment: validEstablishment,
    );
    final validAppliers = [
      validApplier,
      validApplier.copyWith(
        id: validApplierId + 1,
        cns: "214547305740002",
        person: validPersonApplier.copyWith(
          id: validPersonApplierId + 1,
          cpf: "45769124296",
        ),
      ),
      validApplier.copyWith(
        id: validApplierId + 2,
        cns: "924022762700005",
        person: validPersonApplier.copyWith(
          id: validPersonApplierId + 1,
          cpf: "78314952907",
        ),
      ),
    ];

    final validPersonPatientId = 2;
    final validPersonPatient = Person(
      id: validPersonPatientId,
      cpf: "67732120817",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: validLocality,
    );

    final validPriorityGroupId = 1;
    final validPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      groupCode: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    final validPriorityCategoryId = 1;
    final validPriorityCategory = PriorityCategory(
      id: validPriorityCategoryId,
      priorityGroup: validPriorityGroup,
      categoryCode: "Pessoas idosas",
      name: "Idosos",
      description: "Categoria para pessoas idosas",
    );

    final validPatient = Patient(
      id: validPatientId,
      cns: "748477761910001",
      maternalCondition: MaternalCondition.GESTANTE,
      priorityCategory: validPriorityCategory,
      person: validPersonPatient,
    );
    final validPatients = [
      validPatient,
      validPatient.copyWith(
        id: validPatientId + 1,
        cns: "284615030570002",
        person: validPersonPatient.copyWith(
          id: validPersonPatientId + 1,
          cpf: "08895158245",
        ),
      ),
      validPatient.copyWith(
        id: validPatientId + 2,
        cns: "139617028790009",
        person: validPersonPatient.copyWith(
          id: validPersonPatientId + 1,
          cpf: "53967474046",
        ),
      ),
    ];

    final validCampaign = Campaign(
      id: validCampaignId,
      title: "Campaign Title",
      description: "Campaign Description",
      startDate: DateTime(2022),
    );
    final validCampaigns = [
      validCampaign,
      validCampaign.copyWith(
        id: validCampaignId + 1,
        title: "Campaign Title 2",
        description: "Campaign Description 2",
      ),
      validCampaign.copyWith(
        id: validCampaignId + 1,
        title: "Campaign Title 3",
        description: "Campaign Description 3",
        startDate: DateTime(2023),
      ),
    ];

    final validVaccineBatch = VaccineBatch(
      id: validVaccineBatchId,
      batchNo: "123456",
      quantity: 20,
    );
    final validVaccineBatches = [
      validVaccineBatch,
      validVaccineBatch.copyWith(
        id: validVaccineBatchId + 1,
        batchNo: "654321",
      ),
      validVaccineBatch.copyWith(
        id: validVaccineBatchId + 2,
        batchNo: "123457",
      ),
    ];

    final validVaccine = Vaccine(
      id: 1,
      sipniCode: "123456",
      name: "Vaccine Name",
      laboratory: "Laboratory Name",
      vaccineBatch: VaccineBatch(
        id: 1,
        batchNo: "01234",
        quantity: 10,
      ),
    );
    final validVaccines = [
      validVaccine,
      validVaccine.copyWith(
        id: 2,
        sipniCode: "654321",
        name: "Vaccine Name 2",
        vaccineBatch: validVaccineBatches[1],
      ),
      validVaccine.copyWith(
        id: 3,
        sipniCode: "111222",
        name: "Vaccine Name 3",
        vaccineBatch: validVaccineBatches[2],
      ),
    ];

    final expectedApplication = Application(
      id: validApplicationId,
      patient: validPatients[0],
      vaccine: validVaccines[0],
      applicationDate: DateTime(2022, 3, 4),
      applier: validAppliers[0],
      vaccineBatch: validVaccineBatches[0],
      vaccineDose: VaccineDose.D1,
      campaign: validCampaigns[0],
      dueDate: DateTime(2022, 4),
    );
    final expectedApplications = [
      expectedApplication,
      expectedApplication.copyWith(
        id: validApplicationId + 1,
        patient: validPatients[1],
        applicationDate: DateTime(2022, 4, 4),
        applier: validAppliers[1],
        vaccineBatch: validVaccineBatches[1],
        vaccineDose: VaccineDose.D2,
        campaign: validCampaigns[1],
        dueDate: DateTime(2023),
      ),
    ];

    group('try to get all applications', () {
      setUp(() {
        when(db.query(
          DatabaseApplicationRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              'id': expectedApplications[0].id,
              'patient': expectedApplications[0].patient.id,
              'vaccine': expectedApplications[0].vaccine.id,
              'applicationDate': expectedApplications[0]
                  .applicationDate
                  .millisecondsSinceEpoch,
              'applier': expectedApplications[0].applier.id,
              'vaccineBatch': expectedApplications[0].vaccineBatch.id,
              'vaccineDose': expectedApplications[0].vaccineDose.name,
              'campaign': expectedApplications[0].campaign.id,
              'dueDate': expectedApplications[0].dueDate.millisecondsSinceEpoch,
            },
            {
              'id': expectedApplications[1].id,
              'patient': expectedApplications[1].patient.id,
              'vaccine': expectedApplications[1].vaccine.id,
              'applicationDate': expectedApplications[1]
                  .applicationDate
                  .millisecondsSinceEpoch,
              'applier': expectedApplications[1].applier.id,
              'vaccineBatch': expectedApplications[1].vaccineBatch.id,
              'vaccineDose': expectedApplications[1].vaccineDose.name,
              'campaign': expectedApplications[1].campaign.id,
              'dueDate': expectedApplications[1].dueDate.millisecondsSinceEpoch,
            },
          ]),
        );

        when(db.query(
          DatabaseLocalityRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validLocality.id,
              "name": validLocality.name,
              "city": validLocality.city,
              "state": validLocality.state,
              "ibgeCode": validLocality.ibgeCode,
            }
          ]),
        );

        when(db.query(
          DatabasePersonRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validAppliers[0].person.id,
              "cpf": validAppliers[0].person.cpf,
              "name": validAppliers[0].person.name,
              "birthDate":
                  validAppliers[0].person.birthDate.millisecondsSinceEpoch,
              "locality": validAppliers[0].person.locality.id,
            },
            {
              "id": validAppliers[1].person.id,
              "cpf": validAppliers[1].person.cpf,
              "name": validAppliers[1].person.name,
              "birthDate":
                  validAppliers[1].person.birthDate.millisecondsSinceEpoch,
              "locality": validAppliers[1].person.locality.id,
            },
            {
              "id": validAppliers[2].person.id,
              "cpf": validAppliers[2].person.cpf,
              "name": validAppliers[2].person.name,
              "birthDate":
                  validAppliers[2].person.birthDate.millisecondsSinceEpoch,
              "locality": validAppliers[2].person.locality.id,
            },
          ]),
        );

        when(db.query(
          DatabaseEstablishmentRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validEstablishment.id,
              "cnes": validEstablishment.cnes,
              "name": validEstablishment.name,
              "locality": validEstablishment.locality.id,
            }
          ]),
        );

        when(db.query(
          DatabaseApplierRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validAppliers[0].id,
              "cns": validAppliers[0].cns,
              "person": validAppliers[0].person.id,
              "establishment": validAppliers[0].establishment.id,
            },
            {
              "id": validAppliers[1].id,
              "cns": validAppliers[1].cns,
              "person": validAppliers[1].person.id,
              "establishment": validAppliers[1].establishment.id,
            },
            {
              "id": validAppliers[2].id,
              "cns": validAppliers[2].cns,
              "person": validAppliers[2].person.id,
              "establishment": validAppliers[2].establishment.id,
            },
          ]),
        );

        when(db.query(
          DatabasePersonRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validPatients[0].person.id,
              "cpf": validPatients[0].person.cpf,
              "name": validPatients[0].person.name,
              "birthDate":
                  validPatients[0].person.birthDate.millisecondsSinceEpoch,
              "locality": validPatients[0].person.locality.id,
            },
            {
              "id": validPatients[1].person.id,
              "cpf": validPatients[1].person.cpf,
              "name": validPatients[1].person.name,
              "birthDate":
                  validPatients[1].person.birthDate.millisecondsSinceEpoch,
              "locality": validPatients[1].person.locality.id,
            },
            {
              "id": validPatients[2].person.id,
              "cpf": validPatients[2].person.cpf,
              "name": validPatients[2].person.name,
              "birthDate":
                  validPatients[2].person.birthDate.millisecondsSinceEpoch,
              "locality": validPatients[2].person.locality.id,
            },
          ]),
        );

        when(db.query(
          DatabasePriorityGroupRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              'id': validPriorityGroup.id,
              'groupCode': validPriorityGroup.groupCode,
              'name': validPriorityGroup.name,
              'description': validPriorityGroup.description,
            }
          ]),
        );

        when(db.query(
          DatabasePriorityCategoryRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              'id': validPriorityCategory.id,
              'priorityGroup': validPriorityCategory.priorityGroup.id,
              'categoryCode': validPriorityCategory.categoryCode,
              'name': validPriorityCategory.name,
              'description': validPriorityCategory.description,
            }
          ]),
        );

        when(db.query(
          DatabasePatientRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validPatients[0].id,
              "cns": validPatients[0].cns,
              "maternalCondition": validPatients[0].maternalCondition.name,
              "priorityCategory": validPatients[0].priorityCategory.id,
              "person": validPatients[0].person.id,
            },
            {
              "id": validPatients[1].id,
              "cns": validPatients[1].cns,
              "maternalCondition": validPatients[1].maternalCondition.name,
              "priorityCategory": validPatients[1].priorityCategory.id,
              "person": validPatients[1].person.id,
            },
            {
              "id": validPatients[2].id,
              "cns": validPatients[2].cns,
              "maternalCondition": validPatients[2].maternalCondition.name,
              "priorityCategory": validPatients[2].priorityCategory.id,
              "person": validPatients[2].person.id,
            },
          ]),
        );
      });

      when(db.query(
        DatabaseCampaignRepository.TABLE,
      )).thenAnswer(
        (_) => Future.value([
          {
            "id": validCampaigns[0].id,
            "title": validCampaigns[0].title,
            "description": validCampaigns[0].description,
            "startDate": validCampaigns[0].startDate.millisecondsSinceEpoch,
            "endDate": validCampaigns[0].endDate.millisecondsSinceEpoch,
          },
          {
            "id": validCampaigns[1].id,
            "title": validCampaigns[1].title,
            "description": validCampaigns[1].description,
            "startDate": validCampaigns[1].startDate.millisecondsSinceEpoch,
            "endDate": validCampaigns[1].endDate.millisecondsSinceEpoch,
          },
          {
            "id": validCampaigns[2].id,
            "title": validCampaigns[2].title,
            "description": validCampaigns[2].description,
            "startDate": validCampaigns[2].startDate.millisecondsSinceEpoch,
            "endDate": validCampaigns[2].endDate.millisecondsSinceEpoch,
          },
        ]),
      );

      when(db.query(
        DatabaseVaccineBatchRepository.TABLE,
      )).thenAnswer(
        (_) => Future.value([
          {
            "id": validVaccineBatches[0].id,
            "batchNo": validVaccineBatches[0].batchNo,
            "quantity": validVaccineBatches[0].quantity,
          },
          {
            "id": validVaccineBatches[1].id,
            "batchNo": validVaccineBatches[1].batchNo,
            "quantity": validVaccineBatches[1].quantity,
          },
          {
            "id": validVaccineBatches[2].id,
            "batchNo": validVaccineBatches[2].batchNo,
            "quantity": validVaccineBatches[2].quantity,
          },
        ]),
      );
    });

    when(db.query(
      DatabaseVaccineRepository.TABLE,
    )).thenAnswer(
      (_) => Future.value([
        {
          "id": validVaccines[0].id,
          "sipniCode": validVaccines[0].sipniCode,
          "name": validVaccines[0].name,
          "laboratory": validVaccines[0].laboratory,
          "vaccineBatch": validVaccines[0].vaccineBatch.id,
        },
        {
          "id": validVaccines[1].id,
          "sipniCode": validVaccines[1].sipniCode,
          "name": validVaccines[1].name,
          "laboratory": validVaccines[1].laboratory,
          "vaccineBatch": validVaccines[1].vaccineBatch.id,
        },
        {
          "id": validVaccines[2].id,
          "sipniCode": validVaccines[2].sipniCode,
          "name": validVaccines[2].name,
          "laboratory": validVaccines[2].laboratory,
          "vaccineBatch": validVaccines[2].vaccineBatch.id,
        },
      ]),
    );

    test("should return all applications", () async {
      final actualApplications = await repository.getApplications();

      expect(actualApplications, isA<List<Application>>());
      for (int i = 0; i < actualApplications.length; i++) {
        expect(actualApplications[i], expectedApplications[i]);
      }
    });
  });

  group('try to get all applications when there is none', () {
    setUp(() {
      when(db.query(
        DatabaseApplicationRepository.TABLE,
      )).thenAnswer((_) => Future.value([]));
    });

    test("should return an empty list", () async {
      final actualApplications = await repository.getApplications();

      expect(actualApplications, isA<List<Application>>());
      expect(actualApplications, isEmpty);
    });
  });
}

void testUpdateApplication(
  MockDatabase db,
  DatabaseApplicationRepository repository,
) {
  final int invalidApplicationId = 2;
  group("updateApplication function:", () {
    final int validApplicationId = 1;
    final int validPatientId = 1;
    final int validVaccineId = 1;
    final int validApplierId = 1;

    final validLocality = Locality(
      id: 1,
      name: "Locality Name",
      city: "City Name",
      state: "State Name",
      ibgeCode: "1234567",
    );

    final validApplier = Applier(
      id: validApplierId,
      cns: "279197866950004",
      person: Person(
        id: 1,
        cpf: "82675387630",
        name: "Name Middlename Lastname",
        birthDate: DateTime(2000),
        locality: validLocality,
      ),
      establishment: Establishment(
        id: 1,
        cnes: "1234567",
        name: "Establishment Name",
        locality: validLocality,
      ),
    );

    final validPatient = Patient(
      id: validPatientId,
      cns: "748477761910001",
      maternalCondition: MaternalCondition.GESTANTE,
      priorityCategory: PriorityCategory(
        id: 1,
        priorityGroup: PriorityGroup(
          id: 1,
          groupCode: "Pessoas com mais de 60 anos",
        ),
        categoryCode: "Pessoas idosas",
        name: "Idosos",
        description: "Categoria para pessoas idosas",
      ),
      person: Person(
        id: 1,
        cpf: "67732120817",
        name: "Name Middlename Lastname",
        birthDate: DateTime(2000),
        locality: validLocality,
      ),
    );

    final validCampaign = Campaign(
      id: 1,
      title: "Campaign Title",
      description: "Campaign Description",
      startDate: DateTime(2022),
    );

    final validVaccineBatch = VaccineBatch(
      id: 1,
      batchNo: "123456",
      quantity: 20,
    );

    final validVaccine = Vaccine(
      id: validVaccineId,
      sipniCode: "123456",
      name: "Vaccine Name",
      laboratory: "Laboratory Name",
      vaccineBatch: VaccineBatch(
        id: 1,
        batchNo: "01234",
        quantity: 10,
      ),
    );

    final expectedApplication = Application(
      id: validApplicationId,
      patient: validPatient,
      vaccine: validVaccine,
      applicationDate: DateTime(2022, 3, 4),
      applier: validApplier,
      vaccineBatch: validVaccineBatch,
      vaccineDose: VaccineDose.D1,
      campaign: validCampaign,
      dueDate: DateTime(2022, 4),
    );

    group('try to update a valid application', () {
      setUp(() {
        when(db.update(
          DatabaseApplicationRepository.TABLE,
          expectedApplication.copyWith(dueDate: DateTime(2024)).toMap(),
          where: anyNamed("where"),
          whereArgs: [validApplicationId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a application entry and returns 1", () async {
        final createdId = await repository.updateApplication(
          expectedApplication.copyWith(dueDate: DateTime(2024)),
        );

        expect(createdId, 1);
      });
    });

    group('try to update with invalid application', () {
      setUp(() {
        when(db.update(
          DatabaseApplicationRepository.TABLE,
          expectedApplication
              .copyWith(
                id: invalidApplicationId,
                dueDate: DateTime(2024),
              )
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [invalidApplicationId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updateApplication(
          expectedApplication.copyWith(
            id: invalidApplicationId,
            dueDate: DateTime(2024),
          ),
        );

        expect(updatedCount, 0);
      });
    });
  });
}
