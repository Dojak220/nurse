import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_person_repository.dart';
import 'package:nurse/shared/repositories/patient/person_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_person_repository_test.mocks.dart';

@GenerateMocks([
  DatabaseManager,
  Database,
  DatabaseLocalityRepository,
])
void main() {
  final dbMock = MockDatabase();
  final dbManagerMock = MockDatabaseManager();
  final localityRepoMock = MockDatabaseLocalityRepository();

  final repository = DatabasePersonRepository(
    dbManager: dbManagerMock,
    localityRepo: localityRepoMock,
  );

  setUp(() {
    when(dbManagerMock.db).thenReturn(dbMock);
    when(localityRepoMock.getLocalityById(1))
        .thenAnswer((_) async => _validLocality);
    when(localityRepoMock.getLocalityByIbgeCode("1234567"))
        .thenAnswer((_) async => _validLocality);
    when(localityRepoMock.getLocalities())
        .thenAnswer((_) async => _validLocalities);
  });

  testCreatePerson(dbMock, repository);
  testDeletePerson(dbMock, repository);
  testGetPerson(dbMock, repository);
  testGetPersons(dbMock, repository);
  testUpdatePerson(dbMock, repository);
}

void testCreatePerson(MockDatabase db, PersonRepository repository) {
  group("createPerson function:", () {
    group('try to create a valid person', () {
      setUp(() {
        when(db.insert(DatabasePersonRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new person entry and return its id", () async {
        final createdId = await repository.createPerson(_validPerson);

        expect(createdId, 1);
      });
    });
  });
}

void testDeletePerson(MockDatabase db, PersonRepository repository) {
  group("deletePerson function:", () {
    group('try to delete valid person', () {
      setUp(() {
        when(db.delete(
          DatabasePersonRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validPersonId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a person entry and returns 1", () async {
        final deletedCount = await repository.deletePerson(_validPersonId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid person', () {
      setUp(() {
        when(db.delete(
          DatabasePersonRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_invalidPersonId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesnt exist", () async {
        final deletedCount = await repository.deletePerson(_invalidPersonId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetPerson(MockDatabase db, PersonRepository repository) {
  group("getPerson function:", () {
    final expectedPerson = _validPerson.copyWith(cpf: "82675387630");

    group('try to get valid person', () {
      setUp(() {
        when(db.query(
          DatabasePersonRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validPersonId],
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedPerson.id,
                "cpf": expectedPerson.cpf,
                "name": expectedPerson.name,
                "birth_date": expectedPerson.birthDate.toString(),
                "locality": expectedPerson.locality!.id,
                "sex": expectedPerson.sex.name,
                "mother_name": expectedPerson.motherName,
                "father_name": expectedPerson.fatherName,
              }
            ]));
      });

      test("should get a person entry by its id", () async {
        final actualPerson = await repository.getPersonById(_validPersonId);

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

void testGetPersons(MockDatabase db, PersonRepository repository) {
  group("getPersons function:", () {
    final expectedPersons = _validPersons;

    group('try to get all persons', () {
      setUp(() {
        when(db.query(
          DatabasePersonRepository.TABLE,
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedPersons[0].id,
                "cpf": expectedPersons[0].cpf,
                "name": expectedPersons[0].name,
                "birth_date": expectedPersons[0].birthDate.toString(),
                "locality": expectedPersons[0].locality!.id,
                "sex": expectedPersons[0].sex.name,
                "mother_name": expectedPersons[0].motherName,
                "father_name": expectedPersons[0].fatherName,
              },
              {
                "id": expectedPersons[1].id,
                "cpf": expectedPersons[1].cpf,
                "name": expectedPersons[1].name,
                "birth_date": expectedPersons[1].birthDate.toString(),
                "locality": expectedPersons[1].locality!.id,
                "sex": expectedPersons[1].sex.name,
                "mother_name": expectedPersons[1].motherName,
                "father_name": expectedPersons[1].fatherName,
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

void testUpdatePerson(MockDatabase db, PersonRepository repository) {
  group("updatePerson function:", () {
    group('try to update a valid person', () {
      setUp(() {
        when(db.update(
          DatabasePersonRepository.TABLE,
          _validPerson.copyWith(name: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [_validPersonId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a person entry and returns 1", () async {
        final createdId = await repository.updatePerson(
          _validPerson.copyWith(name: "Updated"),
        );

        expect(createdId, 1);
      });
    });
    group('try to update with invalid person', () {
      setUp(() {
        when(db.update(
          DatabasePersonRepository.TABLE,
          _validPerson.copyWith(id: _invalidPersonId, name: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [_invalidPersonId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updatePerson(
          _validPerson.copyWith(id: _invalidPersonId, name: "Updated"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}

const int _validPersonId = 1;
const int _validLocalityId = 1;

const int _invalidPersonId = 2;

final _validLocality = Locality(
  id: _validLocalityId,
  name: "Local",
  city: "Brasília",
  state: "DF",
  ibgeCode: "1234567",
);

final _validPerson = Person(
  id: _validPersonId,
  cpf: "44407857862",
  name: "Name LastName",
  birthDate: DateTime(2000),
  locality: _validLocality,
  sex: Sex.female,
  motherName: "Mãe",
  fatherName: "Pai",
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

final _validLocalities = [
  _validLocality,
  _validLocality.copyWith(
    id: _validLocalityId + 1,
    name: "Local 2",
    ibgeCode: "1234568",
  ),
  _validLocality.copyWith(
    id: _validLocalityId + 2,
    name: "Local 3",
    ibgeCode: "1234569",
  ),
];
