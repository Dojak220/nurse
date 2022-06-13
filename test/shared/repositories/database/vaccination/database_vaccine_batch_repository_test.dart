import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_batch_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_batch_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_vaccine_batch_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabaseVaccineRepository])
void main() {
  final dbMock = MockDatabase();
  final dbManagerMock = MockDatabaseManager();
  final vaccineRepo = MockDatabaseVaccineRepository();

  final repository = DatabaseVaccineBatchRepository(
    dbManagerMock,
    vaccineRepo,
  );

  setUp(() {
    when(dbManagerMock.db).thenReturn(dbMock);
    when(vaccineRepo.getVaccineById(1)).thenAnswer(
      (_) async => _validVaccine,
    );
    when(vaccineRepo.getVaccineBySipniCode("123456")).thenAnswer(
      (_) async => _validVaccine,
    );
    when(vaccineRepo.getVaccines()).thenAnswer(
      (_) async => _validVaccines,
    );
  });

  testCreateVaccineBatch(dbMock, repository);
  testDeleteVaccineBatch(dbMock, repository);
  testGetVaccineBatch(dbMock, repository);
  testGetVaccineBatches(dbMock, repository);
  testUpdateVaccineBatch(dbMock, repository);
}

void testCreateVaccineBatch(
  MockDatabase db,
  VaccineBatchRepository repository,
) {
  group("createVaccineBatch function:", () {
    group('try to create a valid vaccineBatch', () {
      setUp(() {
        when(db.insert(DatabaseVaccineBatchRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new vaccineBatch entry and return its id",
          () async {
        final createdId = await repository.createVaccineBatch(
          _validVaccineBatch,
        );

        expect(createdId, 1);
      });
    });
  });
}

void testDeleteVaccineBatch(
  MockDatabase db,
  VaccineBatchRepository repository,
) {
  group("deleteVaccineBatch function:", () {
    group('try to delete valid vaccineBatch', () {
      setUp(() {
        when(db.delete(
          DatabaseVaccineBatchRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validVaccineBatchId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a vaccineBatch entry and returns 1", () async {
        final deletedCount =
            await repository.deleteVaccineBatch(_validVaccineBatchId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid vaccineBatch', () {
      setUp(() {
        when(db.delete(
          DatabaseVaccineBatchRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_invalidVaccineBatchId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final deletedCount =
            await repository.deleteVaccineBatch(_invalidVaccineBatchId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetVaccineBatch(
  MockDatabase db,
  VaccineBatchRepository repository,
) {
  group("getVaccineBatch function:", () {
    final expectedVaccineBatch = _validVaccineBatch;
    group('try to get valid vaccineBatch', () {
      setUp(() {
        when(db.query(
          DatabaseVaccineBatchRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validVaccineBatchId],
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedVaccineBatch.id,
                "number": expectedVaccineBatch.number,
                "quantity": expectedVaccineBatch.quantity,
                "vaccine": expectedVaccineBatch.vaccine.id,
              }
            ]));

        when(db.query(
          DatabaseVaccineRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validVaccineId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": _validVaccine.id,
              "sipni_code": _validVaccine.sipniCode,
              "name": _validVaccine.name,
              "laboratory": _validVaccine.laboratory,
            }
          ]),
        );
      });

      test("should get a vaccineBatch entry by its id", () async {
        final actualVaccineBatch =
            await repository.getVaccineBatchById(_validVaccineBatchId);

        expect(actualVaccineBatch, isA<VaccineBatch>());
        expect(actualVaccineBatch, expectedVaccineBatch);
      });
    });

    group('try to get an invalid vaccineBatch', () {
      setUp(() {
        when(db.query(
          DatabaseVaccineBatchRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [2],
        )).thenAnswer((_) => Future.value([]));
      });

      test("should throw exception if id doesn't exist", () async {
        expect(
          () async => await repository.getVaccineBatchById(2),
          throwsStateError,
        );
      });
    });
  });
}

void testGetVaccineBatches(
  MockDatabase db,
  VaccineBatchRepository repository,
) {
  group("getVaccineBatches function:", () {
    final expectedVaccineBatches = _validVaccineBatches;
    group('try to get all vaccineBatches', () {
      setUp(() {
        when(db.query(
          DatabaseVaccineBatchRepository.TABLE,
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedVaccineBatches[0].id,
                "number": expectedVaccineBatches[0].number,
                "quantity": expectedVaccineBatches[0].quantity,
                "vaccine": expectedVaccineBatches[0].vaccine.id,
              },
              {
                "id": expectedVaccineBatches[1].id,
                "number": expectedVaccineBatches[1].number,
                "quantity": expectedVaccineBatches[1].quantity,
                "vaccine": expectedVaccineBatches[1].vaccine.id,
              },
              {
                "id": expectedVaccineBatches[2].id,
                "number": expectedVaccineBatches[2].number,
                "quantity": expectedVaccineBatches[2].quantity,
                "vaccine": expectedVaccineBatches[2].vaccine.id,
              },
            ]));
      });

      test("should return all vaccineBatches", () async {
        final actualVaccineBatches = await repository.getVaccineBatches();

        expect(actualVaccineBatches, isA<List<VaccineBatch>>());
        for (int i = 0; i < actualVaccineBatches.length; i++) {
          expect(actualVaccineBatches[i], expectedVaccineBatches[i]);
        }
      });
    });

    group('try to get all vaccineBatches when there is none', () {
      setUp(() {
        when(db.query(
          DatabaseVaccineBatchRepository.TABLE,
        )).thenAnswer((_) => Future.value([]));
      });

      test("should return an empty list", () async {
        final actualVaccineBatches = await repository.getVaccineBatches();

        expect(actualVaccineBatches, isA<List<VaccineBatch>>());
        expect(actualVaccineBatches, isEmpty);
      });
    });
  });
}

void testUpdateVaccineBatch(
  MockDatabase db,
  VaccineBatchRepository repository,
) {
  group("updateVaccineBatch function:", () {
    group('try to update a valid vaccineBatch', () {
      setUp(() {
        when(db.update(
          DatabaseVaccineBatchRepository.TABLE,
          _validVaccineBatch.copyWith(quantity: 50).toMap(),
          where: anyNamed("where"),
          whereArgs: [_validVaccineBatchId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a vaccineBatch entry and returns 1", () async {
        final updatedCount = await repository.updateVaccineBatch(
          _validVaccineBatch.copyWith(quantity: 50),
        );

        expect(updatedCount, 1);
      });
    });

    group('try to update invalid vaccineBatch', () {
      setUp(() {
        when(db.update(
          DatabaseVaccineBatchRepository.TABLE,
          _validVaccineBatch
              .copyWith(id: _invalidVaccineBatchId, quantity: 50)
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [_invalidVaccineBatchId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updateVaccineBatch(
          _validVaccineBatch.copyWith(id: _invalidVaccineBatchId, quantity: 50),
        );

        expect(updatedCount, 0);
      });
    });
  });
}

final int _validVaccineBatchId = 1;
final int _validVaccineId = 1;

final int _invalidVaccineBatchId = 2;

final _validVaccine = Vaccine(
  id: _validVaccineId,
  sipniCode: "123456",
  name: "Vaccine Name",
  laboratory: "Laboratory Name",
);

final _validVaccineBatch = VaccineBatch(
  id: _validVaccineBatchId,
  number: "123456",
  quantity: 20,
  vaccine: _validVaccine,
);

final _validVaccines = [
  _validVaccine,
  _validVaccine.copyWith(
    id: _validVaccineId + 1,
    sipniCode: "123457",
    name: "Vaccine Name 2",
    laboratory: "Laboratory Name 2",
  ),
];

final _validVaccineBatches = [
  _validVaccineBatch,
  _validVaccineBatch.copyWith(
    id: _validVaccineBatchId + 1,
    number: "123457",
    quantity: 30,
    vaccine: _validVaccines[1],
  ),
  _validVaccineBatch.copyWith(
    id: _validVaccineBatchId + 2,
    number: "123458",
    quantity: 40,
    vaccine: _validVaccines[1],
  ),
];
