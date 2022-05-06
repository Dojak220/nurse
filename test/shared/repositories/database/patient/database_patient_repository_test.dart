import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_patient_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_person_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_patient_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabasePatientRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();

  final repository = DatabasePatientRepository();

  setUp(() {
    when(dbManager.db).thenReturn(db);
  });

  testCreatePatient(db, repository);
  testDeletePatient(db, repository);
  testGetPatient(db, repository);
  testGetPatients(db, repository);
  testUpdatePatient(db, repository);
}

void testCreatePatient(
  MockDatabase db,
  DatabasePatientRepository repository,
) {
  group("createPatient function:", () {
    final int validPatientId = 1;
    final int validPriorityGroupId = 1;
    final int validPriorityCategoryId = 1;
    final int validLocalityId = 1;

    final validPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      code: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    final validPriorityCategory = PriorityCategory(
      id: validPriorityCategoryId,
      priorityGroup: validPriorityGroup,
      code: "Pessoas idosas",
      name: "Idosos",
      description: "Categoria para pessoas idosas",
    );

    final validLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );

    final validPatient = Patient(
      id: validPatientId,
      cns: "138068523490004",
      maternalCondition: MaternalCondition.GESTANTE,
      priorityCategory: validPriorityCategory,
      person: Person(
        id: validPatientId,
        cpf: "44407857862",
        name: "Teste",
        birthDate: DateTime(2000),
        locality: validLocality,
        sex: Sex.MALE,
        motherName: "Mãe",
        fatherName: "Pai",
      ),
    );

    group('try to create a valid patient', () {
      setUp(() {
        when(db.insert(any, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new patient entry and return its id", () async {
        final createdId = await repository.createPatient(validPatient);

        expect(createdId, 1);
      });

      test("should create a new patient entry and return its id", () async {
        final createdId = await repository.createPatient(
          validPatient.copyWith(cns: "856359713320003"),
        );

        expect(createdId, 1);
      });
    });
  });
}

void testDeletePatient(
  MockDatabase db,
  DatabasePatientRepository repository,
) {
  group("deletePatient function:", () {
    final int validPatientId = 1;
    final int invalidPatientId = 2;

    group('try to delete valid patient', () {
      setUp(() {
        when(db.delete(
          DatabasePatientRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPatientId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete an patient entry and returns 1", () async {
        final deletedCount = await repository.deletePatient(validPatientId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid patient', () {
      setUp(() {
        when(db.delete(
          DatabasePatientRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [invalidPatientId],
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
        final deletedCount = await repository.deletePatient(invalidPatientId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetPatient(
  MockDatabase db,
  DatabasePatientRepository repository,
) {
  group("getPatient function:", () {
    final int validPatientId = 1;
    final int validPersonId = 1;
    final int validLocalityId = 1;
    final int validPriorityGroupId = 1;
    final int validPriorityCategoryId = 1;

    final validLocality = Locality(
      id: validLocalityId,
      name: "Locality Name",
      city: "City Name",
      state: "State Name",
      ibgeCode: "1234567",
    );

    final validPerson = Person(
      id: validPersonId,
      cpf: "73654421580",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: validLocality,
    );

    final validPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      code: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    final validPriorityCategory = PriorityCategory(
      id: validPriorityCategoryId,
      priorityGroup: validPriorityGroup,
      code: "Pessoas idosas",
      name: "Idosos",
      description: "Categoria para pessoas idosas",
    );

    final expectedPatient = Patient(
      id: validPatientId,
      cns: "734759395100004",
      maternalCondition: MaternalCondition.GESTANTE,
      person: validPerson,
      priorityCategory: validPriorityCategory,
    );

    group('try to get valid patient', () {
      setUp(() {
        when(db.query(
          DatabasePatientRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPatientId],
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedPatient.id,
                "cns": expectedPatient.cns,
                "maternal_condition": expectedPatient.maternalCondition.name,
                "person": expectedPatient.person.id,
                "priority_category": expectedPatient.priorityCategory.id,
              }
            ]));

        when(db.query(
          DatabasePersonRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPersonId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validPerson.id,
              "cpf": validPerson.cpf,
              "name": validPerson.name,
              "birth_date": validPerson.birthDate.toString(),
              "locality": validPerson.locality.id,
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
              "id": validPriorityCategory.id,
              "priority_group": validPriorityCategory.priorityGroup.id,
              "code": validPriorityCategory.code,
              "name": validPriorityCategory.name,
              "description": validPriorityCategory.description,
            }
          ]),
        );
        when(db.query(
          DatabasePriorityGroupRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPersonId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validPriorityGroup.id,
              "code": validPriorityGroup.code,
              "name": validPriorityGroup.name,
              "description": validPriorityGroup.description,
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
              "ibge_code": validLocality.ibgeCode,
            }
          ]),
        );
      });

      test("should get a patient entry by its id", () async {
        final actualPatient = await repository.getPatientById(validPatientId);

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

void testGetPatients(
  MockDatabase db,
  DatabasePatientRepository repository,
) {
  group("getPatients function:", () {
    final int validLocalityId = 1;
    final int validPersonId = 1;
    final int validPriorityGroupId = 1;
    final int validPriorityCategoryId = 1;
    final int validPatientId = 1;

    final validLocality = Locality(
      id: validLocalityId,
      name: "Locality Name",
      city: "City Name",
      state: "State Name",
      ibgeCode: "1234567",
    );

    final validPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      code: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    final validPersons = [
      Person(
        id: validPersonId,
        cpf: "73654421580",
        name: "Name Middlename Lastname",
        birthDate: DateTime(2000),
        locality: validLocality,
      ),
      Person(
        id: validPersonId + 1,
        cpf: "81251763731",
        name: "Middlename Lastname",
        birthDate: DateTime(2000),
        locality: validLocality,
      ),
      Person(
        id: validPersonId + 2,
        cpf: "28771177825",
        name: "Name Lastname",
        birthDate: DateTime(2000),
        locality: validLocality,
      ),
    ];

    final validPriorityCategory = [
      PriorityCategory(
        id: validPriorityCategoryId,
        priorityGroup: validPriorityGroup,
        code: "Pessoas idosas",
        name: "Idosos",
        description: "Categoria para pessoas idosas",
      ),
      PriorityCategory(
        id: validPriorityCategoryId + 1,
        priorityGroup: validPriorityGroup,
        code: "Pessoas menores de idade",
        name: "Adolescentes",
        description: "Categoria de adolescentes",
      ),
      PriorityCategory(
        id: validPriorityCategoryId + 2,
        priorityGroup: validPriorityGroup,
        code: "Pessoas com menos de 12 anos",
        name: "Crianças",
        description: "Categoria de crianças",
      ),
    ];
    final expectedPatients = [
      Patient(
        id: validPatientId,
        cns: "734759395100004",
        maternalCondition: MaternalCondition.GESTANTE,
        person: validPersons[0],
        priorityCategory: validPriorityCategory[0],
      ),
      Patient(
        id: validPatientId + 1,
        cns: "982223824070006",
        maternalCondition: MaternalCondition.GESTANTE,
        person: validPersons[1],
        priorityCategory: validPriorityCategory[1],
      ),
      Patient(
        id: validPatientId + 2,
        cns: "293934886890002",
        maternalCondition: MaternalCondition.GESTANTE,
        person: validPersons[2],
        priorityCategory: validPriorityCategory[2],
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
                "maternal_condition": expectedPatients[0].maternalCondition,
                "person": expectedPatients[0].person,
                "priority_category": expectedPatients[0].priorityCategory,
              },
              {
                "id": expectedPatients[1].id,
                "cns": expectedPatients[1].cns,
                "maternal_condition": expectedPatients[1].maternalCondition,
                "person": expectedPatients[1].person,
                "priority_category": expectedPatients[1].priorityCategory,
              },
              {
                "id": expectedPatients[2].id,
                "cns": expectedPatients[2].cns,
                "maternal_condition": expectedPatients[2].maternalCondition,
                "person": expectedPatients[2].person,
                "priority_category": expectedPatients[2].priorityCategory,
              },
            ]));
        when(db.query(
          DatabasePersonRepository.TABLE,
        )).thenAnswer((_) => Future.value([
              {
                "id": validPersons[0].id,
                "cpf": validPersons[0].cpf,
                "name": validPersons[0].name,
                "birth_date": validPersons[0].birthDate,
                "locality": validPersons[0].locality,
              },
              {
                "id": validPersons[1].id,
                "cpf": validPersons[1].cpf,
                "name": validPersons[1].name,
                "birth_date": validPersons[1].birthDate,
                "locality": validPersons[1].locality,
              },
              {
                "id": validPersons[2].id,
                "cpf": validPersons[2].cpf,
                "name": validPersons[2].name,
                "birth_date": validPersons[2].birthDate,
                "locality": validPersons[2].locality,
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

void testUpdatePatient(
  MockDatabase db,
  DatabasePatientRepository repository,
) {
  group("updatePatient function:", () {
    final int validPatientId = 1;
    final int invalidPatientId = 2;
    final int validPersonId = 1;
    final int validLocalityId = 1;
    final int validPriorityGroupId = 1;
    final int validPriorityCategoryId = 1;

    final validLocality = Locality(
      id: validLocalityId,
      name: "Locality Name",
      city: "City Name",
      state: "State Name",
      ibgeCode: "1234567",
    );

    final validPerson = Person(
      id: validPersonId,
      cpf: "73654421580",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: validLocality,
    );

    final validPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      code: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    final validPriorityCategory = PriorityCategory(
      id: validPriorityCategoryId,
      priorityGroup: validPriorityGroup,
      code: "Pessoas idosas",
      name: "Idosos",
      description: "Categoria para pessoas idosas",
    );

    final validPatient = Patient(
      id: validPatientId,
      cns: "734759395100004",
      maternalCondition: MaternalCondition.GESTANTE,
      person: validPerson,
      priorityCategory: validPriorityCategory,
    );

    group('try to update a valid patient', () {
      setUp(() {
        when(db.update(
          DatabasePatientRepository.TABLE,
          validPatient.copyWith(cns: "793499756240009").toMap(),
          where: anyNamed("where"),
          whereArgs: [validPatientId],
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
