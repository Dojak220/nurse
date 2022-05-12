import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/infra/establishment_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_establishment_repository_test.mocks.dart';

@GenerateMocks([
  DatabaseManager,
  Database,
  DatabaseLocalityRepository,
])
void main() {
  final dbMock = MockDatabase();
  final dbManagerMock = MockDatabaseManager();
  final localityRepoMock = MockDatabaseLocalityRepository();

  final repository = DatabaseEstablishmentRepository(
    dbManager: dbManagerMock,
    localityRepo: localityRepoMock,
  );

  setUp(() {
    when(dbManagerMock.db).thenReturn(dbMock);
    when(localityRepoMock.getLocalityById(1)).thenAnswer(
      (_) async => _validLocality,
    );
    when(localityRepoMock.getLocalities()).thenAnswer(
      (_) async => _validLocalities,
    );
  });

  testCreateEstablishment(dbMock, repository);
  testDeleteEstablishment(dbMock, repository);
  testGetEstablishment(dbMock, repository);
  testGetEstablishments(dbMock, repository);
  testUpdateEstablishment(dbMock, repository);
}

void testCreateEstablishment(
  MockDatabase db,
  EstablishmentRepository repository,
) {
  group("createEstablishment function:", () {
    group('try to create a valid establishment', () {
      setUp(() {
        when(db.insert(DatabaseEstablishmentRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new establishment entry and return its id",
          () async {
        final createdId =
            await repository.createEstablishment(_validEstablishment);

        expect(createdId, 1);
      });
    });
  });
}

void testDeleteEstablishment(
    MockDatabase db, EstablishmentRepository repository) {
  group("deleteEstablishment function:", () {
    group('try to delete valid establishment', () {
      setUp(() {
        when(db.delete(
          DatabaseEstablishmentRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validEstablishmentId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete an establishment entry and returns 1", () async {
        final deletedCount =
            await repository.deleteEstablishment(_validEstablishmentId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid establishment', () {
      setUp(() {
        when(db.delete(
          DatabaseEstablishmentRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_invalidEstablishmentId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesnt exist", () async {
        final deletedCount =
            await repository.deleteEstablishment(_invalidEstablishmentId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetEstablishment(MockDatabase db, EstablishmentRepository repository) {
  group("getEstablishment function:", () {
    final int _validEstablishmentId = 1;
    final int validLocalityId = 1;
    final expectedLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );
    final expectedEstablishment = Establishment(
      id: _validEstablishmentId,
      cnes: "1234567",
      name: "Test",
      locality: expectedLocality,
    );

    group('try to get valid establishment', () {
      setUp(() {
        when(db.query(
          DatabaseEstablishmentRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validEstablishmentId],
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
              "ibge_code": expectedLocality.ibgeCode,
            }
          ]),
        );
      });

      test("should get an establishment entry by its id", () async {
        final actualEstablishment =
            await repository.getEstablishmentById(_validEstablishmentId);

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
    MockDatabase db, EstablishmentRepository repository) {
  group("getEstablishments function:", () {
    final expectedEstablishments = _validEstablishments;

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
    MockDatabase db, EstablishmentRepository repository) {
  group("updateEstablishment function:", () {
    group('try to update a valid establishment', () {
      setUp(() {
        when(db.update(
          DatabaseEstablishmentRepository.TABLE,
          _validEstablishment.copyWith(name: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [_validEstablishmentId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a establishment entry and returns 1", () async {
        final createdId = await repository.updateEstablishment(
          _validEstablishment.copyWith(name: "Updated"),
        );

        expect(createdId, 1);
      });
    });
    group('try to update with invalid establishment', () {
      setUp(() {
        when(db.update(
          DatabaseEstablishmentRepository.TABLE,
          _validEstablishment
              .copyWith(id: _invalidEstablishmentId, name: "Updated")
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [_invalidEstablishmentId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updateEstablishment(
          _validEstablishment.copyWith(
              id: _invalidEstablishmentId, name: "Updated"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}

final int _validLocalityId = 1;
final int _validEstablishmentId = 1;
final int _invalidEstablishmentId = 2;

final _validLocality = Locality(
  id: _validLocalityId,
  name: "Local",
  city: "Brasília",
  state: "DF",
  ibgeCode: "1234567",
);
final _validEstablishment = Establishment(
  id: _validEstablishmentId,
  cnes: "1234567",
  name: "Test",
  locality: _validLocality,
);

final _validLocalities = [
  _validLocality,
  _validLocality.copyWith(
    id: _validLocalityId + 1,
    name: "Segundo Local",
    ibgeCode: "1234568",
  ),
  _validLocality.copyWith(
    id: _validLocalityId + 2,
    name: "Terceiro Local",
    ibgeCode: "1234567",
  ),
];
final _validEstablishments = [
  _validEstablishment,
  _validEstablishment.copyWith(
    id: _validEstablishmentId + 1,
    cnes: "1234568",
    name: "Segundo Estabelecimento",
    locality: _validLocalities[1],
  ),
];
