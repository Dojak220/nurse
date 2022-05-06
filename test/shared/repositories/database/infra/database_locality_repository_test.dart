import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_locality_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabaseLocalityRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();

  final repository = DatabaseLocalityRepository();

  setUp(() {
    when(dbManager.db).thenReturn(db);
  });

  testCreateLocality(db, repository);
  testDeleteLocality(db, repository);
  testGetLocality(db, repository);
  testGetLocalities(db, repository);
  testUpdateLocality(db, repository);
}

void testCreateLocality(
  MockDatabase db,
  DatabaseLocalityRepository repository,
) {
  group("createLocality function:", () {
    final int validLocalityId = 1;
    final validLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );

    group('try to create a valid locality', () {
      setUp(() {
        when(db.insert(DatabaseLocalityRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new locality entry and return its id", () async {
        final createdId = await repository.createLocality(validLocality);

        expect(createdId, 1);
      });
    });
  });
}

void testDeleteLocality(
  MockDatabase db,
  DatabaseLocalityRepository repository,
) {
  group("deleteLocality function:", () {
    final int validLocalityId = 1;
    final int invalidLocalityId = 2;

    group('try to delete valid locality', () {
      setUp(() {
        when(db.delete(
          DatabaseLocalityRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validLocalityId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a locality entry and returns 1", () async {
        final deletedCount = await repository.deleteLocality(validLocalityId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid locality', () {
      setUp(() {
        when(db.delete(
          DatabaseLocalityRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [invalidLocalityId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final deletedCount = await repository.deleteLocality(invalidLocalityId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetLocality(
  MockDatabase db,
  DatabaseLocalityRepository repository,
) {
  group("getLocality function:", () {
    final int validLocalityId = 1;
    final expectedLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );

    group('try to get valid locality', () {
      setUp(() {
        when(db.query(
          DatabaseLocalityRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validLocalityId],
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedLocality.id,
                "name": expectedLocality.name,
                "city": expectedLocality.city,
                "state": expectedLocality.state,
                "ibge_code": expectedLocality.ibgeCode,
              }
            ]));
      });

      test("should get a locality entry by its id", () async {
        final actualLocality =
            await repository.getLocalityById(validLocalityId);

        expect(actualLocality, isA<Locality>());
        expect(actualLocality, expectedLocality);
      });
    });

    group('try to get an invalid locality', () {
      setUp(() {
        when(db.query(
          DatabaseLocalityRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [2],
        )).thenAnswer((_) => Future.value([]));
      });

      test("should throw exception if id doesn't exist", () async {
        expect(
          () async => await repository.getLocalityById(2),
          throwsStateError,
        );
      });
    });
  });
}

void testGetLocalities(
  MockDatabase db,
  DatabaseLocalityRepository repository,
) {
  group("getLocalities function:", () {
    final int validLocalityId = 1;
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

    group('try to get all localities', () {
      setUp(() {
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

      test("should return all localities", () async {
        final actualLocalities = await repository.getLocalities();

        expect(actualLocalities, isA<List<Locality>>());
        for (int i = 0; i < actualLocalities.length; i++) {
          expect(actualLocalities[i], expectedLocalities[i]);
        }
      });
    });

    group('try to get all localities when there is none', () {
      setUp(() {
        when(db.query(
          DatabaseLocalityRepository.TABLE,
        )).thenAnswer((_) => Future.value([]));
      });

      test("should return an empty list", () async {
        final actualLocalities = await repository.getLocalities();

        expect(actualLocalities, isA<List<Locality>>());
        expect(actualLocalities, isEmpty);
      });
    });
  });
}

void testUpdateLocality(
  MockDatabase db,
  DatabaseLocalityRepository repository,
) {
  group("updateLocality function:", () {
    final int validLocalityId = 1;
    final int invalidLocalityId = 2;
    final validLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );

    group('try to update a valid locality', () {
      setUp(() {
        when(db.update(
          DatabaseLocalityRepository.TABLE,
          validLocality.copyWith(name: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [validLocalityId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a locality entry and returns 1", () async {
        final updatedCount = await repository.updateLocality(
          validLocality.copyWith(name: "Updated"),
        );

        expect(updatedCount, 1);
      });
    });

    group('try to update invalid locality', () {
      setUp(() {
        when(db.update(
          DatabaseLocalityRepository.TABLE,
          validLocality
              .copyWith(id: invalidLocalityId, name: "Updated")
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [invalidLocalityId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updateLocality(
          validLocality.copyWith(id: invalidLocalityId, name: "Updated"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}
