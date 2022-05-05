import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_person_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_person_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabasePersonRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();

  final repository = DatabasePersonRepository(dbManager);

  setUp(() {
    when(dbManager.db).thenReturn(db);
  });

  testCreatePerson(db, repository);
  testDeletePerson(db, repository);
  testGetPerson(db, repository);
  testGetPersons(db, repository);
  testUpdatePerson(db, repository);
}

void testCreatePerson(
  MockDatabase db,
  DatabasePersonRepository repository,
) {
  group("createPerson function:", () {
    final int validPersonId = 1;
    final int validLocalityId = 1;

    final expectedLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );

    final validPerson = Person(
      id: validPersonId,
      cpf: "82675387630",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: expectedLocality,
    );

    group('try to create a valid person', () {
      setUp(() {
        when(db.insert(DatabasePersonRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new person entry and return its id", () async {
        final createdId = await repository.createPerson(validPerson);

        expect(createdId, 1);
      });
    });
  });
}

void testDeletePerson(
  MockDatabase db,
  DatabasePersonRepository repository,
) {
  group("deletePerson function:", () {
    final int validPersonId = 1;
    final int invalidPersonId = 2;

    group('try to delete valid person', () {
      setUp(() {
        when(db.delete(
          DatabasePersonRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPersonId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a person entry and returns 1", () async {
        final deletedCount = await repository.deletePerson(validPersonId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid person', () {
      setUp(() {
        when(db.delete(
          DatabasePersonRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [invalidPersonId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesnt exist", () async {
        final deletedCount = await repository.deletePerson(invalidPersonId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetPerson(
  MockDatabase db,
  DatabasePersonRepository repository,
) {
  group("getPerson function:", () {
    final int validPersonId = 1;
    final int validLocalityId = 1;
    final expectedLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );
    final expectedPerson = Person(
      id: validPersonId,
      cpf: "82675387630",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: expectedLocality,
    );

    group('try to get valid person', () {
      setUp(() {
        when(db.query(
          DatabasePersonRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPersonId],
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedPerson.id,
                "cpf": expectedPerson.cpf,
                "name": expectedPerson.name,
                "birth_date": expectedPerson.birthDate.millisecondsSinceEpoch,
                "locality": expectedPerson.locality.id,
              }
            ]));

        when(db.query(
          DatabaseLocalityRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validLocalityId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": expectedLocality.id,
              "name": expectedLocality.name,
              "city": expectedLocality.city,
              "state": expectedLocality.state,
              "ibge_code": expectedLocality.ibgeCode,
            }
          ]),
        );
      });

      test("should get a person entry by its id", () async {
        final actualPerson = await repository.getPersonById(validPersonId);

        expect(actualPerson, isA<Person>());
        expect(actualPerson, expectedPerson);
      });
    });

    group('try to get an invalid person', () {
      setUp(() {
        when(db.query(
          DatabasePersonRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [2],
        )).thenAnswer((_) => Future.value([]));
      });

      test("should throw exception if id doesn't exist", () async {
        expect(
          () async => await repository.getPersonById(2),
          throwsStateError,
        );
      });
    });
  });
}

void testGetPersons(
  MockDatabase db,
  DatabasePersonRepository repository,
) {
  group("getPersons function:", () {
    final int validLocalityId = 1;
    final int validPersonId = 1;
    final expectedLocalities = [
      Locality(
        id: validLocalityId,
        name: "Primeiro Local",
        city: "Brasília",
        state: "DF",
        ibgeCode: "1234567",
      ),
      Locality(
        id: validLocalityId + 1,
        name: "Segundo Local",
        city: "Brasília",
        state: "DF",
        ibgeCode: "1234567",
      ),
      Locality(
        id: validLocalityId + 2,
        name: "Terceiro Local",
        city: "Brasília",
        state: "DF",
        ibgeCode: "1234567",
      ),
    ];
    final expectedPersons = [
      Person(
        id: validPersonId,
        cpf: "82675387630",
        name: "Name Middlename Lastname",
        birthDate: DateTime(2000),
        locality: expectedLocalities[0],
      ),
      Person(
        id: validPersonId + 1,
        cpf: "00661741206",
        name: "Name Middlename Lastname",
        birthDate: DateTime(2000),
        locality: expectedLocalities[1],
      ),
    ];

    group('try to get all persons', () {
      setUp(() {
        when(db.query(
          DatabasePersonRepository.TABLE,
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedPersons[0].id,
                "cpf": expectedPersons[0].cpf,
                "name": expectedPersons[0].name,
                "birth_date": expectedPersons[0].birthDate,
                "locality": expectedPersons[0].locality,
              },
              {
                "id": expectedPersons[1].id,
                "cpf": expectedPersons[1].cpf,
                "name": expectedPersons[1].name,
                "birth_date": expectedPersons[1].birthDate,
                "locality": expectedPersons[1].locality,
              },
            ]));
        when(db.query(
          DatabaseLocalityRepository.TABLE,
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedLocalities[0].id,
                "name": expectedLocalities[0].name,
                "city": expectedLocalities[0].city,
                "state": expectedLocalities[0].state,
                "ibge_code": expectedLocalities[0].ibgeCode,
              },
              {
                "id": expectedLocalities[1].id,
                "name": expectedLocalities[1].name,
                "city": expectedLocalities[1].city,
                "state": expectedLocalities[1].state,
                "ibge_code": expectedLocalities[1].ibgeCode,
              },
              {
                "id": expectedLocalities[2].id,
                "name": expectedLocalities[2].name,
                "city": expectedLocalities[2].city,
                "state": expectedLocalities[2].state,
                "ibge_code": expectedLocalities[2].ibgeCode,
              },
            ]));
      });

      test("should return all persons", () async {
        final actualPersons = await repository.getPersons();

        expect(actualPersons, isA<List<Person>>());
        for (int i = 0; i < actualPersons.length; i++) {
          expect(actualPersons[i], expectedPersons[i]);
        }
      });
    });

    group('try to get all persons when there is none', () {
      setUp(() {
        when(db.query(
          DatabasePersonRepository.TABLE,
        )).thenAnswer((_) => Future.value([]));
      });

      test("should return an empty list", () async {
        final actualPersons = await repository.getPersons();

        expect(actualPersons, isA<List<Person>>());
        expect(actualPersons, isEmpty);
      });
    });
  });
}

void testUpdatePerson(
  MockDatabase db,
  DatabasePersonRepository repository,
) {
  final int invalidPersonId = 2;
  group("updatePerson function:", () {
    final int validPersonId = 1;
    final int validLocalityId = 1;
    final expectedLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );
    final validPerson = Person(
      id: validPersonId,
      cpf: "76614434306",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: expectedLocality,
    );

    group('try to update a valid person', () {
      setUp(() {
        when(db.update(
          DatabasePersonRepository.TABLE,
          validPerson.copyWith(name: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [validPersonId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a person entry and returns 1", () async {
        final createdId = await repository.updatePerson(
          validPerson.copyWith(name: "Updated"),
        );

        expect(createdId, 1);
      });
    });
    group('try to update with invalid person', () {
      setUp(() {
        when(db.update(
          DatabasePersonRepository.TABLE,
          validPerson.copyWith(id: invalidPersonId, name: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [invalidPersonId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updatePerson(
          validPerson.copyWith(id: invalidPersonId, name: "Updated"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}
