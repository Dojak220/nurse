import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_establishment_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabaseEstablishmentRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();

  final repository = DatabaseEstablishmentRepository(dbManager);

  setUp(() {
    when(dbManager.db).thenReturn(db);
  });

  testCreateEstablishment(db, repository);
  testDeleteEstablishment(db, repository);
  testGetEstablishment(db, repository);
  testGetEstablishments(db, repository);
  testUpdateEstablishment(db, repository);
}

void testCreateEstablishment(
  MockDatabase db,
  DatabaseEstablishmentRepository repository,
) {
  group("createEstablishment function:", () {
    final int validEstablishmentId = 1;
    final int validLocalityId = 1;
    final expectedLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );
    final validEstablishment = Establishment(
      id: validEstablishmentId,
      cnes: "1234567",
      name: "Test",
      locality: expectedLocality,
    );

    group('try to create a valid establishment', () {
      setUp(() {
        when(db.insert(DatabaseEstablishmentRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new establishment entry and return its id",
          () async {
        final createdId =
            await repository.createEstablishment(validEstablishment);

        expect(createdId, 1);
      });
    });
  });
}

void testDeleteEstablishment(
  MockDatabase db,
  DatabaseEstablishmentRepository repository,
) {
  group("deleteEstablishment function:", () {
    final int validEstablishmentId = 1;
    final int invalidEstablishmentId = 2;

    group('try to delete valid establishment', () {
      setUp(() {
        when(db.delete(
          DatabaseEstablishmentRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validEstablishmentId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete an establishment entry and returns 1", () async {
        final deletedCount =
            await repository.deleteEstablishment(validEstablishmentId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid establishment', () {
      setUp(() {
        when(db.delete(
          DatabaseEstablishmentRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [invalidEstablishmentId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesnt exist", () async {
        final deletedCount =
            await repository.deleteEstablishment(invalidEstablishmentId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetEstablishment(
  MockDatabase db,
  DatabaseEstablishmentRepository repository,
) {
  group("getEstablishment function:", () {
    final int validEstablishmentId = 1;
    final int validLocalityId = 1;
    final expectedLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );
    final expectedEstablishment = Establishment(
      id: validEstablishmentId,
      cnes: "1234567",
      name: "Test",
      locality: expectedLocality,
    );

    group('try to get valid establishment', () {
      setUp(() {
        when(db.query(
          DatabaseEstablishmentRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validEstablishmentId],
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedEstablishment.id,
                "cnes": expectedEstablishment.cnes,
                "name": expectedEstablishment.name,
                "locality": expectedEstablishment.locality.id,
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
              "ibgeCode": expectedLocality.ibgeCode,
            }
          ]),
        );
      });

      test("should get an establishment entry by its id", () async {
        final actualEstablishment =
            await repository.getEstablishmentById(validEstablishmentId);

        expect(actualEstablishment, isA<Establishment>());
        expect(actualEstablishment, expectedEstablishment);
      });
    });

    group('try to get an invalid establishment', () {
      setUp(() {
        when(db.query(
          DatabaseEstablishmentRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [2],
        )).thenAnswer((_) => Future.value([]));
      });

      test("should throw exception if id doesn't exist", () async {
        expect(
          () async => await repository.getEstablishmentById(2),
          throwsStateError,
        );
      });
    });
  });
}

void testGetEstablishments(
  MockDatabase db,
  DatabaseEstablishmentRepository repository,
) {
  group("getEstablishments function:", () {
    final int validLocalityId = 1;
    final int validEstablishmentId = 1;
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
    final expectedEstablishments = [
      Establishment(
        id: validEstablishmentId,
        cnes: "1234567",
        name: "Test",
        locality: expectedLocalities[0],
      ),
      Establishment(
        id: validEstablishmentId + 1,
        cnes: "1234568",
        name: "Segundo Estabelecimento",
        locality: expectedLocalities[1],
      ),
    ];

    group('try to get all establishments', () {
      setUp(() {
        when(db.query(
          DatabaseEstablishmentRepository.TABLE,
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedEstablishments[0].id,
                "cnes": expectedEstablishments[0].cnes,
                "name": expectedEstablishments[0].name,
                "locality": expectedEstablishments[0].locality.id,
              },
              {
                "id": expectedEstablishments[1].id,
                "cnes": expectedEstablishments[1].cnes,
                "name": expectedEstablishments[1].name,
                "locality": expectedEstablishments[1].locality.id,
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
                "ibgeCode": expectedLocalities[0].ibgeCode,
              },
              {
                "id": expectedLocalities[1].id,
                "name": expectedLocalities[1].name,
                "city": expectedLocalities[1].city,
                "state": expectedLocalities[1].state,
                "ibgeCode": expectedLocalities[1].ibgeCode,
              },
              {
                "id": expectedLocalities[2].id,
                "name": expectedLocalities[2].name,
                "city": expectedLocalities[2].city,
                "state": expectedLocalities[2].state,
                "ibgeCode": expectedLocalities[2].ibgeCode,
              },
            ]));
      });

      test("should return all establishments", () async {
        final actualEstablishments = await repository.getEstablishments();

        expect(actualEstablishments, isA<List<Establishment>>());
        for (int i = 0; i < actualEstablishments.length; i++) {
          expect(actualEstablishments[i], expectedEstablishments[i]);
        }
      });
    });

    group('try to get all establishments when there is none', () {
      setUp(() {
        when(db.query(
          DatabaseEstablishmentRepository.TABLE,
        )).thenAnswer((_) => Future.value([]));
      });

      test("should return an empty list", () async {
        final actualEstablishments = await repository.getEstablishments();

        expect(actualEstablishments, isA<List<Establishment>>());
        expect(actualEstablishments, isEmpty);
      });
    });
  });
}

void testUpdateEstablishment(
  MockDatabase db,
  DatabaseEstablishmentRepository repository,
) {
  final int invalidEstablishmentId = 2;
  group("updateEstablishment function:", () {
    final int validEstablishmentId = 1;
    final int validLocalityId = 1;
    final expectedLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );
    final validEstablishment = Establishment(
      id: validEstablishmentId,
      cnes: "1234567",
      name: "Old Name",
      locality: expectedLocality,
    );

    group('try to update a valid establishment', () {
      setUp(() {
        when(db.update(
          DatabaseEstablishmentRepository.TABLE,
          validEstablishment.copyWith(name: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [validEstablishmentId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a establishment entry and returns 1", () async {
        final createdId = await repository.updateEstablishment(
          validEstablishment.copyWith(name: "Updated"),
        );

        expect(createdId, 1);
      });
    });
    group('try to update with invalid establishment', () {
      setUp(() {
        when(db.update(
          DatabaseEstablishmentRepository.TABLE,
          validEstablishment
              .copyWith(id: invalidEstablishmentId, name: "Updated")
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [invalidEstablishmentId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updateEstablishment(
          validEstablishment.copyWith(
              id: invalidEstablishmentId, name: "Updated"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}
