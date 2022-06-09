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
import 'package:nurse/shared/repositories/database/patient/database_patient_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_application_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_applier_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart';
import 'package:nurse/shared/repositories/vaccination/application_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_application_repository_test.mocks.dart';

@GenerateMocks([
  DatabaseManager,
  Database,
  DatabasePatientRepository,
  DatabaseVaccineRepository,
  DatabaseApplierRepository,
  DatabaseCampaignRepository,
])
void main() {
  final dbMock = MockDatabase();
  final dbManagerMock = MockDatabaseManager();
  final applierRepoMock = MockDatabaseApplierRepository();
  final vaccineRepoMock = MockDatabaseVaccineRepository();
  final campaignRepoMock = MockDatabaseCampaignRepository();
  final patientRepoMock = MockDatabasePatientRepository();

  final repository = DatabaseApplicationRepository(
    dbManager: dbManagerMock,
    applierRepo: applierRepoMock,
    vaccineRepo: vaccineRepoMock,
    campaignRepo: campaignRepoMock,
    patientRepo: patientRepoMock,
  );

  setUp(() {
    when(dbManagerMock.db).thenReturn(dbMock);
    when(applierRepoMock.getApplierById(1)).thenAnswer(
      (_) async => _validApplier,
    );
    when(applierRepoMock.getApplierByCns("279197866950004")).thenAnswer(
      (_) async => _validApplier,
    );
    when(applierRepoMock.getAppliers()).thenAnswer((_) async => _validAppliers);
    when(vaccineRepoMock.getVaccineById(1)).thenAnswer(
      (_) async => _validVaccine,
    );
    when(vaccineRepoMock.getVaccineBySipniCode("123456")).thenAnswer(
      (_) async => _validVaccine,
    );
    when(vaccineRepoMock.getVaccines()).thenAnswer((_) async => _validVaccines);
    when(campaignRepoMock.getCampaignById(1)).thenAnswer(
      (_) async => _validCampaign,
    );
    when(campaignRepoMock.getCampaignByTitle("Campaign Title")).thenAnswer(
      (_) async => _validCampaign,
    );
    when(campaignRepoMock.getCampaigns()).thenAnswer(
      (_) async => _validCampaigns,
    );
    when(patientRepoMock.getPatientById(1)).thenAnswer(
      (_) async => _validPatient,
    );
    when(patientRepoMock.getPatientByCns("748477761910001")).thenAnswer(
      (_) async => _validPatient,
    );
    when(patientRepoMock.getPatients()).thenAnswer((_) async => _validPatients);
  });

  testCreateApplication(dbMock, repository);
  testDeleteApplication(dbMock, repository);
  testGetApplication(dbMock, repository);
  testGetApplications(dbMock, repository);
  testUpdateApplication(dbMock, repository);
}

void testCreateApplication(MockDatabase db, ApplicationRepository repository) {
  group("createApplication function:", () {
    group('try to create a valid application', () {
      setUp(() {
        when(db.insert(DatabaseApplicationRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new application entry and return its id", () async {
        final newId = await repository.createApplication(_validApplication);

        expect(newId, 1);
      });
    });
  });
}

void testDeleteApplication(MockDatabase db, ApplicationRepository repository) {
  group("deleteApplication function:", () {
    group('try to delete valid application', () {
      setUp(() {
        when(db.delete(
          DatabaseApplicationRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validApplicationId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete an application entry and returns 1", () async {
        final deletedCount =
            await repository.deleteApplication(_validApplicationId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid application', () {
      setUp(() {
        when(db.delete(
          DatabaseApplicationRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_invalidApplicationId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesnt exist", () async {
        final deletedCount =
            await repository.deleteApplication(_invalidApplicationId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetApplication(MockDatabase db, ApplicationRepository repository) {
  group("getApplication function:", () {
    final expectedApplication = _validApplication;

    group('try to get valid application', () {
      setUp(() {
        when(db.query(
          DatabaseApplicationRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validApplicationId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": expectedApplication.id,
              "patient": expectedApplication.patient.id,
              "vaccine": expectedApplication.vaccine.id,
              "application_date":
                  expectedApplication.applicationDate.toString(),
              "applier": expectedApplication.applier.id,
              "dose": expectedApplication.dose.name,
              "campaign": expectedApplication.campaign.id,
              "due_date": expectedApplication.dueDate.toString(),
            }
          ]),
        );
      });

      test("should get a application entry by its id", () async {
        final actualApplication =
            await repository.getApplicationById(_validApplicationId);

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

void testGetApplications(MockDatabase db, ApplicationRepository repository) {
  group("getApplications function:", () {
    final expectedApplications = _validApplications;

    group('try to get all applications', () {
      setUp(() {
        when(db.query(
          DatabaseApplicationRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": expectedApplications[0].id,
              "patient": expectedApplications[0].patient.id,
              "vaccine": expectedApplications[0].vaccine.id,
              "application_date":
                  expectedApplications[0].applicationDate.toString(),
              "applier": expectedApplications[0].applier.id,
              "dose": expectedApplications[0].dose.name,
              "campaign": expectedApplications[0].campaign.id,
              "due_date": expectedApplications[0].dueDate.toString(),
            },
            {
              "id": expectedApplications[1].id,
              "patient": expectedApplications[1].patient.id,
              "vaccine": expectedApplications[1].vaccine.id,
              "application_date":
                  expectedApplications[1].applicationDate.toString(),
              "applier": expectedApplications[1].applier.id,
              "dose": expectedApplications[1].dose.name,
              "campaign": expectedApplications[1].campaign.id,
              "due_date": expectedApplications[1].dueDate.toString(),
            },
          ]),
        );
      });

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
  });
}

void testUpdateApplication(MockDatabase db, ApplicationRepository repository) {
  group("updateApplication function:", () {
    group('try to update a valid application', () {
      setUp(() {
        when(db.update(
          DatabaseApplicationRepository.TABLE,
          _validApplication.copyWith(dueDate: DateTime(2024)).toMap(),
          where: anyNamed("where"),
          whereArgs: [_validApplicationId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a application entry and returns 1", () async {
        final createdId = await repository.updateApplication(
          _validApplication.copyWith(dueDate: DateTime(2024)),
        );

        expect(createdId, 1);
      });
    });

    group('try to update with invalid application', () {
      setUp(() {
        when(db.update(
          DatabaseApplicationRepository.TABLE,
          _validApplication
              .copyWith(
                id: _invalidApplicationId,
                dueDate: DateTime(2024),
              )
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [_invalidApplicationId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updateApplication(
          _validApplication.copyWith(
            id: _invalidApplicationId,
            dueDate: DateTime(2024),
          ),
        );

        expect(updatedCount, 0);
      });
    });
  });
}

final int _validApplicationId = 1;
final int _validPatientId = 1;
final int _validVaccineId = 1;
final int _validApplierId = 1;
final int _validCampaignId = 1;
final int _validPersonId = 1;
final int _validVaccineBatchId = 1;

final int _invalidApplicationId = 2;

final _validLocality = Locality(
  id: 1,
  name: "Locality Name",
  city: "City Name",
  state: "State Name",
  ibgeCode: "1234567",
);

final _validApplier = Applier(
  id: _validApplierId,
  cns: "279197866950004",
  person: Person(
    id: 1,
    cpf: "82675387630",
    name: "Name Middlename Lastname",
    birthDate: DateTime(2000),
    locality: _validLocality,
  ),
  establishment: Establishment(
    id: 1,
    cnes: "1234567",
    name: "Establishment Name",
    locality: _validLocality,
  ),
);

final _validPerson = Person(
  id: _validPersonId,
  cpf: "67732120817",
  name: "Name Middlename Lastname",
  birthDate: DateTime(2000),
  locality: _validLocality,
);

final _validPatient = Patient(
  id: _validPatientId,
  cns: "748477761910001",
  maternalCondition: MaternalCondition.GESTANTE,
  priorityCategory: PriorityCategory(
    id: 1,
    priorityGroup: PriorityGroup(
      id: 1,
      code: "Pessoas com mais de 60 anos",
    ),
    code: "Pessoas idosas",
    name: "Idosos",
    description: "Categoria para pessoas idosas",
  ),
  person: _validPerson,
);

final _validCampaign = Campaign(
  id: 1,
  title: "Campaign Title",
  description: "Campaign Description",
  startDate: DateTime(2022),
);

final _validVaccine = Vaccine(
  id: _validVaccineId,
  sipniCode: "123456",
  name: "Vaccine Name",
  laboratory: "Laboratory Name",
  batch: VaccineBatch(
    id: 1,
    number: "01234",
    quantity: 10,
  ),
);

final _validApplication = Application(
  id: _validApplicationId,
  patient: _validPatient,
  vaccine: _validVaccine,
  applicationDate: DateTime(2022, 3, 4),
  applier: _validApplier,
  dose: VaccineDose.D1,
  campaign: _validCampaign,
  dueDate: DateTime(2022, 4),
);

final _validPatients = [
  _validPatient,
  _validPatient.copyWith(
    id: _validPatientId + 1,
    cns: "284615030570002",
    person: _validPerson.copyWith(
      id: _validPersonId + 1,
      cpf: "08895158245",
    ),
  ),
  _validPatient.copyWith(
    id: _validPatientId + 2,
    cns: "139617028790009",
    person: _validPerson.copyWith(
      id: _validPersonId + 1,
      cpf: "53967474046",
    ),
  ),
];

final _validCampaigns = [
  _validCampaign,
  _validCampaign.copyWith(
    id: _validCampaignId + 1,
    title: "Campaign Title 2",
    description: "Campaign Description 2",
  ),
  _validCampaign.copyWith(
    id: _validCampaignId + 1,
    title: "Campaign Title 3",
    description: "Campaign Description 3",
    startDate: DateTime(2023),
  ),
];

final _validVaccineBatch = VaccineBatch(
  id: _validVaccineBatchId,
  number: "123456",
  quantity: 20,
);
final _validVaccineBatches = [
  _validVaccineBatch,
  _validVaccineBatch.copyWith(
    id: _validVaccineBatchId + 1,
    number: "654321",
  ),
  _validVaccineBatch.copyWith(
    id: _validVaccineBatchId + 2,
    number: "123457",
  ),
];

final _validVaccines = [
  _validVaccine,
  _validVaccine.copyWith(
    id: 2,
    sipniCode: "654321",
    name: "Vaccine Name 2",
    batch: _validVaccineBatches[1],
  ),
  _validVaccine.copyWith(
    id: 3,
    sipniCode: "111222",
    name: "Vaccine Name 3",
    batch: _validVaccineBatches[2],
  ),
];

final _validAppliers = [
  _validApplier,
  _validApplier.copyWith(
    id: _validApplierId + 1,
    cns: "214547305740002",
    person: _validPerson.copyWith(
      id: _validPersonId + 1,
      cpf: "45769124296",
    ),
  ),
  _validApplier.copyWith(
    id: _validApplierId + 2,
    cns: "924022762700005",
    person: _validPerson.copyWith(
      id: _validPersonId + 1,
      cpf: "78314952907",
    ),
  ),
];

final _validApplications = [
  _validApplication,
  _validApplication.copyWith(
    id: _validApplicationId + 1,
    patient: _validPatients[1],
    applicationDate: DateTime(2022, 4, 4),
    applier: _validAppliers[1],
    dose: VaccineDose.D2,
    campaign: _validCampaigns[1],
    dueDate: DateTime(2023),
  ),
];
