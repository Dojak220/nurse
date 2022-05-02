import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_batch_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_vaccine_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabaseVaccineRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();

  final repository = DatabaseVaccineRepository(dbManager);

  setUp(() {
    when(dbManager.db).thenReturn(db);
  });

  testCreateVaccine(db, repository);
  testDeleteVaccine(db, repository);
  testGetVaccine(db, repository);
  testGetVaccines(db, repository);
  testUpdateVaccine(db, repository);
}

void testCreateVaccine(
  MockDatabase db,
  DatabaseVaccineRepository repository,
) {
  group("createVaccine function:", () {
    final int validVaccineId = 1;
    final int validVaccineBatchId = 1;

    final validVaccineBatch = VaccineBatch(
      id: validVaccineBatchId,
      batchNo: "01234",
      quantity: 10,
    );

    final validVaccine = Vaccine(
      id: validVaccineId,
      sipniCode: "123456",
      name: "Vaccine Name",
      laboratory: "Laboratory Name",
      vaccineBatch: validVaccineBatch,
    );

    group('try to create a valid vaccine', () {
      setUp(() {
        when(db.insert(DatabaseVaccineRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new vaccine entry and return its id", () async {
        final createdId = await repository.createVaccine(validVaccine);

        expect(createdId, 1);
      });
    });
  });
}

void testDeleteVaccine(
  MockDatabase db,
  DatabaseVaccineRepository repository,
) {
  group("deleteVaccine function:", () {
    final int validVaccineId = 1;
    final int invalidVaccineId = 2;

    group('try to delete valid vaccine', () {
      setUp(() {
        when(db.delete(
          DatabaseVaccineRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validVaccineId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a vaccine entry and returns 1", () async {
        final deletedCount = await repository.deleteVaccine(validVaccineId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid vaccine', () {
      setUp(() {
        when(db.delete(
          DatabaseVaccineRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [invalidVaccineId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesnt exist", () async {
        final deletedCount = await repository.deleteVaccine(invalidVaccineId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetVaccine(
  MockDatabase db,
  DatabaseVaccineRepository repository,
) {
  group("getVaccine function:", () {
    final int validVaccineId = 1;
    final int validVaccineBatchId = 1;
    final validVaccineBatch = VaccineBatch(
      id: 1,
      batchNo: "01234",
      quantity: 10,
    );
    final expectedVaccine = Vaccine(
      id: 1,
      sipniCode: "123456",
      name: "Vaccine Name",
      laboratory: "Laboratory Name",
      vaccineBatch: validVaccineBatch,
    );

    group('try to get valid vaccine', () {
      setUp(() {
        when(db.query(
          DatabaseVaccineRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validVaccineId],
        )).thenAnswer((_) => Future.value([
              {
                'id': expectedVaccine.id,
                'sipniCode': expectedVaccine.sipniCode,
                'name': expectedVaccine.name,
                'laboratory': expectedVaccine.laboratory,
                'vaccineBatch': expectedVaccine.vaccineBatch.id,
              }
            ]));

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
      });

      test("should get a vaccine entry by its id", () async {
        final actualVaccine = await repository.getVaccineById(validVaccineId);

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

void testGetVaccines(
  MockDatabase db,
  DatabaseVaccineRepository repository,
) {
  group("getVaccines function:", () {
    final int validVaccineBatchId = 1;
    final int validVaccineId = 1;
    final validVaccineBatches = [
      VaccineBatch(
        id: validVaccineBatchId,
        batchNo: "01234",
        quantity: 10,
      ),
      VaccineBatch(
        id: validVaccineBatchId + 1,
        batchNo: "01235",
        quantity: 10,
      ),
      VaccineBatch(
        id: validVaccineBatchId + 2,
        batchNo: "01236",
        quantity: 10,
      ),
    ];
    final expectedVaccines = [
      Vaccine(
        id: validVaccineId,
        sipniCode: "123456",
        name: "Vaccine Name",
        laboratory: "Laboratory Name",
        vaccineBatch: validVaccineBatches[0],
      ),
      Vaccine(
        id: validVaccineId + 1,
        sipniCode: "123457",
        name: "Vaccine Name 2",
        laboratory: "Laboratory Name",
        vaccineBatch: validVaccineBatches[1],
      ),
    ];

    group('try to get all vaccines', () {
      setUp(() {
        when(db.query(
          DatabaseVaccineRepository.TABLE,
        )).thenAnswer((_) => Future.value([
              {
                'id': expectedVaccines[0].id,
                'sipniCode': expectedVaccines[0].sipniCode,
                'name': expectedVaccines[0].name,
                'laboratory': expectedVaccines[0].laboratory,
                'vaccineBatch': expectedVaccines[0].vaccineBatch,
              },
              {
                'id': expectedVaccines[1].id,
                'sipniCode': expectedVaccines[1].sipniCode,
                'name': expectedVaccines[1].name,
                'laboratory': expectedVaccines[1].laboratory,
                'vaccineBatch': expectedVaccines[1].vaccineBatch,
              },
            ]));
        when(db.query(
          DatabaseVaccineBatchRepository.TABLE,
        )).thenAnswer((_) => Future.value([
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

void testUpdateVaccine(
  MockDatabase db,
  DatabaseVaccineRepository repository,
) {
  final int invalidVaccineId = 2;
  group("updateVaccine function:", () {
    final int validVaccineId = 1;
    final int validVaccineBatchId = 1;
    final validVaccineBatch = VaccineBatch(
      id: validVaccineBatchId,
      batchNo: "01234",
      quantity: 10,
    );
    final validVaccine = Vaccine(
      id: 1,
      sipniCode: "123456",
      name: "Vaccine Name",
      laboratory: "Laboratory Name",
      vaccineBatch: validVaccineBatch,
    );

    group('try to update a valid vaccine', () {
      setUp(() {
        when(db.update(
          DatabaseVaccineRepository.TABLE,
          validVaccine.copyWith(name: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [validVaccineId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a vaccine entry and returns 1", () async {
        final createdId = await repository.updateVaccine(
          validVaccine.copyWith(name: "Updated"),
        );

        expect(createdId, 1);
      });
    });
    group('try to update with invalid vaccine', () {
      setUp(() {
        when(db.update(
          DatabaseVaccineRepository.TABLE,
          validVaccine.copyWith(id: invalidVaccineId, name: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [invalidVaccineId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updateVaccine(
          validVaccine.copyWith(id: invalidVaccineId, name: "Updated"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}
