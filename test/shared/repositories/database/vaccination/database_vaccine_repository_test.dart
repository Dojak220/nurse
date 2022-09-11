import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_vaccine_repository_test.mocks.dart';

@GenerateMocks([
  DatabaseManager,
  Database,
])
void main() {
  final dbMock = MockDatabase();
  final dbManagerMock = MockDatabaseManager();

  final repository = DatabaseVaccineRepository(
    dbManager: dbManagerMock,
  );

  setUp(() {
    when(dbManagerMock.db).thenReturn(dbMock);
  });

  testCreateVaccine(dbMock, repository);
  testDeleteVaccine(dbMock, repository);
  testGetVaccine(dbMock, repository);
  testGetVaccines(dbMock, repository);
  testUpdateVaccine(dbMock, repository);
}

void testCreateVaccine(MockDatabase db, VaccineRepository repository) {
  group("createVaccine function:", () {
    group('try to create a valid vaccine', () {
      setUp(() {
        when(db.insert(DatabaseVaccineRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new vaccine entry and return its id", () async {
        final createdId = await repository.createVaccine(_validVaccine);

        expect(createdId, 1);
      });
    });
  });
}

void testDeleteVaccine(MockDatabase db, VaccineRepository repository) {
  group("deleteVaccine function:", () {
    group('try to delete valid vaccine', () {
      setUp(() {
        when(db.delete(
          DatabaseVaccineRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validVaccineId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a vaccine entry and returns 1", () async {
        final deletedCount = await repository.deleteVaccine(_validVaccineId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid vaccine', () {
      setUp(() {
        when(db.delete(
          DatabaseVaccineRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_invalidVaccineId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesnt exist", () async {
        final deletedCount = await repository.deleteVaccine(_invalidVaccineId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetVaccine(MockDatabase db, VaccineRepository repository) {
  group("getVaccine function:", () {
    final expectedVaccine = _validVaccine;

    group('try to get valid vaccine', () {
      setUp(() {
        when(db.query(
          DatabaseVaccineRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validVaccineId],
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedVaccine.id,
                "sipni_code": expectedVaccine.sipniCode,
                "name": expectedVaccine.name,
                "laboratory": expectedVaccine.laboratory,
              }
            ]));
      });

      test("should get a vaccine entry by its id", () async {
        final actualVaccine = await repository.getVaccineById(_validVaccineId);

        expect(actualVaccine, isA<Vaccine>());
        expect(actualVaccine, expectedVaccine);
      });
    });

    group('try to get an invalid vaccine', () {
      setUp(() {
        when(db.query(
          DatabaseVaccineRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [2],
        )).thenAnswer((_) => Future.value([]));
      });

      test("should throw exception if id doesn't exist", () async {
        expect(
          () async => await repository.getVaccineById(2),
          throwsStateError,
        );
      });
    });
  });
}

void testGetVaccines(MockDatabase db, VaccineRepository repository) {
  group("getVaccines function:", () {
    final expectedVaccines = _validVaccines;

    group('try to get all vaccines', () {
      setUp(() {
        when(db.query(
          DatabaseVaccineRepository.TABLE,
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedVaccines[0].id,
                "sipni_code": expectedVaccines[0].sipniCode,
                "name": expectedVaccines[0].name,
                "laboratory": expectedVaccines[0].laboratory,
              },
              {
                "id": expectedVaccines[1].id,
                "sipni_code": expectedVaccines[1].sipniCode,
                "name": expectedVaccines[1].name,
                "laboratory": expectedVaccines[1].laboratory,
              },
            ]));
      });

      test("should return all vaccines", () async {
        final actualVaccines = await repository.getVaccines();

        expect(actualVaccines, isA<List<Vaccine>>());
        for (int i = 0; i < actualVaccines.length; i++) {
          expect(actualVaccines[i], expectedVaccines[i]);
        }
      });
    });

    group('try to get all vaccines when there is none', () {
      setUp(() {
        when(db.query(
          DatabaseVaccineRepository.TABLE,
        )).thenAnswer((_) => Future.value([]));
      });

      test("should return an empty list", () async {
        final actualVaccines = await repository.getVaccines();

        expect(actualVaccines, isA<List<Vaccine>>());
        expect(actualVaccines, isEmpty);
      });
    });
  });
}

void testUpdateVaccine(MockDatabase db, VaccineRepository repository) {
  const int invalidVaccineId = 2;
  group("updateVaccine function:", () {
    group('try to update a valid vaccine', () {
      setUp(() {
        when(db.update(
          DatabaseVaccineRepository.TABLE,
          _validVaccine.copyWith(name: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [_validVaccineId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a vaccine entry and returns 1", () async {
        final createdId = await repository.updateVaccine(
          _validVaccine.copyWith(name: "Updated"),
        );

        expect(createdId, 1);
      });
    });
    group('try to update with invalid vaccine', () {
      setUp(() {
        when(db.update(
          DatabaseVaccineRepository.TABLE,
          _validVaccine.copyWith(id: invalidVaccineId, name: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [invalidVaccineId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updateVaccine(
          _validVaccine.copyWith(id: invalidVaccineId, name: "Updated"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}

const int _validVaccineId = 1;

const int _invalidVaccineId = 2;

// final _validVaccineBatch = VaccineBatch(
//   id: _validVaccineBatchId,
//   number: "01234",
//   quantity: 10,
// );

final _validVaccine = Vaccine(
  id: _validVaccineId,
  sipniCode: "123456",
  name: "Vaccine Name",
  laboratory: "Laboratory Name",
  // batch: _validVaccineBatch,
);

// final _validVaccineBatches = [
//   VaccineBatch(
//     id: _validVaccineBatchId,
//     number: "01234",
//     quantity: 10,
//   ),
//   VaccineBatch(
//     id: _validVaccineBatchId + 1,
//     number: "01235",
//     quantity: 10,
//   ),
//   VaccineBatch(
//     id: _validVaccineBatchId + 2,
//     number: "01236",
//     quantity: 10,
//   ),
// ];

final _validVaccines = [
  Vaccine(
    id: _validVaccineId,
    sipniCode: "123456",
    name: "Vaccine Name",
    laboratory: "Laboratory Name",
    // batch: _validVaccineBatches[0],
  ),
  Vaccine(
    id: _validVaccineId + 1,
    sipniCode: "123457",
    name: "Vaccine Name 2",
    laboratory: "Laboratory Name",
    // batch: _validVaccineBatches[1],
  ),
];
