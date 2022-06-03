import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/patient/database_patient_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_person_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/patient/patient_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_patient_repository_test.mocks.dart';

@GenerateMocks([
  DatabaseManager,
  Database,
  DatabasePersonRepository,
  DatabasePriorityCategoryRepository,
])
void main() {
  final dbMock = MockDatabase();
  final dbManagerMock = MockDatabaseManager();
  final personRepoMock = MockDatabasePersonRepository();
  final categoryRepoMock = MockDatabasePriorityCategoryRepository();

  final repository = DatabasePatientRepository(
    dbManager: dbManagerMock,
    personRepo: personRepoMock,
    categoryRepo: categoryRepoMock,
  );

  setUp(() {
    when(dbManagerMock.db).thenReturn(dbMock);
    when(personRepoMock.getPersonById(1)).thenAnswer((_) async => _validPerson);
    when(personRepoMock.getPersons()).thenAnswer((_) async => _validPersons);
    when(categoryRepoMock.getPriorityCategoryById(1)).thenAnswer(
      (_) async => _validPriorityCategory,
    );
    when(categoryRepoMock.getPriorityCategories()).thenAnswer(
      (_) async => _validPriorityCategories,
    );
  });

  testCreatePatient(dbMock, repository);
  testDeletePatient(dbMock, repository);
  testGetPatient(dbMock, repository);
  testGetPatients(dbMock, repository);
  testUpdatePatient(dbMock, repository);
}

void testCreatePatient(MockDatabase db, PatientRepository repository) {
  group("createPatient function:", () {
    group('try to create a valid patient', () {
      setUp(() {
        when(db.insert(any, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new patient entry and return its id", () async {
        final createdId = await repository.createPatient(_validPatient);

        expect(createdId, 1);
      });

      test("should create a new patient entry and return its id", () async {
        final createdId = await repository.createPatient(
          _validPatient.copyWith(cns: "856359713320003"),
        );

        expect(createdId, 1);
      });
    });
  });
}

void testDeletePatient(MockDatabase db, PatientRepository repository) {
  group("deletePatient function:", () {
    group('try to delete valid patient', () {
      setUp(() {
        when(db.delete(
          DatabasePatientRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validPatientId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete an patient entry and returns 1", () async {
        final deletedCount = await repository.deletePatient(_validPatientId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid patient', () {
      setUp(() {
        when(db.delete(
          DatabasePatientRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_invalidPatientId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should throw exception if id is 0", () async {
        expect(
          () async => await repository.deletePatient(0),
          throwsException,
        );
      });

      test("should throw exception if id is negative", () async {
        expect(
          () async => await repository.deletePatient(-1),
          throwsException,
        );
      });

      test("should return 0 if id doesnt exist", () async {
        final deletedCount = await repository.deletePatient(_invalidPatientId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetPatient(MockDatabase db, PatientRepository repository) {
  group("getPatient function:", () {
    final expectedPatient = _validPatient.copyWith(cns: "734759395100004");

    group('try to get valid patient', () {
      setUp(() {
        when(db.query(
          DatabasePatientRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validPatientId],
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedPatient.id,
                "cns": expectedPatient.cns,
                "maternal_condition": expectedPatient.maternalCondition.name,
                "person": expectedPatient.person.id,
                "priority_category": expectedPatient.priorityCategory.id,
              }
            ]));
      });

      test("should get a patient entry by its id", () async {
        final actualPatient = await repository.getPatientById(_validPatientId);

        expect(actualPatient, isA<Patient>());
        expect(actualPatient, expectedPatient);
      });
    });

    group('try to get an invalid patient', () {
      setUp(() {
        when(db.query(
          DatabasePatientRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [2],
        )).thenAnswer((_) => Future.value([]));
      });

      test("should throw exception if id doesn't exist", () async {
        expect(
          () async => await repository.getPatientById(2),
          throwsStateError,
        );
      });
    });
  });
}

void testGetPatients(MockDatabase db, PatientRepository repository) {
  group("getPatients function:", () {
    final expectedPatients = [
      _validPatient.copyWith(
        cns: "734759395100004",
        person: _validPersons[0],
        priorityCategory: _validPriorityCategories[0],
      ),
      _validPatient.copyWith(
        cns: "982223824070006",
        person: _validPersons[1],
        priorityCategory: _validPriorityCategories[1],
      ),
      _validPatient.copyWith(
        cns: "293934886890002",
        person: _validPersons[2],
        priorityCategory: _validPriorityCategories[2],
      ),
    ];

    group('try to get all patients', () {
      setUp(() {
        when(db.query(
          DatabasePatientRepository.TABLE,
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedPatients[0].id,
                "cns": expectedPatients[0].cns,
                "maternal_condition":
                    expectedPatients[0].maternalCondition.name,
                "person": expectedPatients[0].person.id,
                "priority_category": expectedPatients[0].priorityCategory.id,
              },
              {
                "id": expectedPatients[1].id,
                "cns": expectedPatients[1].cns,
                "maternal_condition":
                    expectedPatients[1].maternalCondition.name,
                "person": expectedPatients[1].person.id,
                "priority_category": expectedPatients[1].priorityCategory.id,
              },
              {
                "id": expectedPatients[2].id,
                "cns": expectedPatients[2].cns,
                "maternal_condition":
                    expectedPatients[2].maternalCondition.name,
                "person": expectedPatients[2].person.id,
                "priority_category": expectedPatients[2].priorityCategory.id,
              },
            ]));
      });

      test("should return all patients", () async {
        final actualPatients = await repository.getPatients();

        expect(actualPatients, isA<List<Patient>>());
        for (int i = 0; i < actualPatients.length; i++) {
          expect(actualPatients[i], expectedPatients[i]);
        }
      });
    });

    group('try to get all patients when there is none', () {
      setUp(() {
        when(db.query(
          DatabasePatientRepository.TABLE,
        )).thenAnswer((_) => Future.value([]));
      });

      test("should return an empty list", () async {
        final actualPatients = await repository.getPatients();

        expect(actualPatients, isA<List<Patient>>());
        expect(actualPatients, isEmpty);
      });
    });
  });
}

void testUpdatePatient(MockDatabase db, PatientRepository repository) {
  group("updatePatient function:", () {
    final int invalidPatientId = 2;

    final validPatient = Patient(
      id: _validPatientId,
      cns: "734759395100004",
      maternalCondition: MaternalCondition.GESTANTE,
      person: _validPerson,
      priorityCategory: _validPriorityCategory,
    );

    group('try to update a valid patient', () {
      setUp(() {
        when(db.update(
          DatabasePatientRepository.TABLE,
          validPatient.copyWith(cns: "793499756240009").toMap(),
          where: anyNamed("where"),
          whereArgs: [_validPatientId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a patient entry and returns 1", () async {
        final createdId = await repository.updatePatient(
          validPatient.copyWith(cns: "793499756240009"),
        );

        expect(createdId, 1);
      });
    });

    group('try to update with invalid patient', () {
      setUp(() {
        when(db.update(
          DatabasePatientRepository.TABLE,
          validPatient
              .copyWith(id: invalidPatientId, cns: "793499756240009")
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [invalidPatientId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updatePatient(
          validPatient.copyWith(id: invalidPatientId, cns: "793499756240009"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}

final int _validPatientId = 1;
final int _validLocalityId = 1;
final int _validPersonId = 1;
final int _validPriorityGroupId = 1;
final int _validPriorityCategoryId = 1;

final int _invalidPatientId = 2;

final _validLocality = Locality(
  id: _validLocalityId,
  name: "Locality Name",
  city: "City Name",
  state: "State Name",
  ibgeCode: "1234567",
);

final _validPerson = Person(
  id: _validPersonId,
  cpf: "44407857862",
  name: "Name LastName",
  birthDate: DateTime(2000),
  locality: _validLocality,
  sex: Sex.FEMALE,
  motherName: "Mãe",
  fatherName: "Pai",
);

final _validPriorityGroup = PriorityGroup(
  id: _validPriorityGroupId,
  code: "Pessoas com mais de 60 anos",
  name: "Idosos",
  description: "Grupo de pessoas com mais de 60 anos",
);

final _validPriorityCategory = PriorityCategory(
  id: _validPriorityCategoryId,
  priorityGroup: _validPriorityGroup,
  code: "Pessoas idosas",
  name: "Idosos",
  description: "Categoria para pessoas idosas",
);

final _validPatient = Patient(
  id: _validPatientId,
  cns: "138068523490004",
  maternalCondition: MaternalCondition.GESTANTE,
  priorityCategory: _validPriorityCategory,
  person: _validPerson,
);

final _validPersons = [
  _validPerson,
  _validPerson.copyWith(
    id: _validPersonId + 1,
    cpf: "73654421580",
  ),
  _validPerson.copyWith(
    id: _validPersonId + 2,
    cpf: "81251763731",
  ),
];

final _validPriorityCategories = [
  _validPriorityCategory,
  _validPriorityCategory.copyWith(
    id: _validPriorityCategoryId + 1,
    code: "Pessoas menores de idade",
    name: "Adolescentes",
    description: "Categoria de adolescentes",
  ),
  _validPriorityCategory.copyWith(
    id: _validPriorityCategoryId + 2,
    code: "Pessoas com menos de 12 anos",
    name: "Crianças",
    description: "Categoria de crianças",
  ),
];
