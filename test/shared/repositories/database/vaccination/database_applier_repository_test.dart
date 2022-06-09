import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_person_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_applier_repository.dart';
import 'package:nurse/shared/repositories/vaccination/applier_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_applier_repository_test.mocks.dart';

@GenerateMocks([
  DatabaseManager,
  Database,
  DatabaseEstablishmentRepository,
  DatabasePersonRepository,
])
void main() {
  final dbMock = MockDatabase();
  final dbManagerMock = MockDatabaseManager();
  final personRepoMock = MockDatabasePersonRepository();
  final establishmentRepoMock = MockDatabaseEstablishmentRepository();

  final repository = DatabaseApplierRepository(
    dbManager: dbManagerMock,
    personRepo: personRepoMock,
    establishmentRepo: establishmentRepoMock,
  );

  setUp(() {
    when(dbManagerMock.db).thenReturn(dbMock);
    when(personRepoMock.getPersonById(1)).thenAnswer((_) async => _validPerson);
    when(personRepoMock.createPerson(_validPerson)).thenAnswer((_) async => 1);
    when(personRepoMock.getPersons()).thenAnswer((_) async => _validPersons);
    when(establishmentRepoMock.getEstablishmentById(1))
        .thenAnswer((_) async => _validEstablishment);
    when(establishmentRepoMock.getEstablishmentByCnes("1234567"))
        .thenAnswer((_) async => _validEstablishment);
    when(establishmentRepoMock.getEstablishments())
        .thenAnswer((_) async => _validEstablishments);
  });

  testCreateApplier(dbMock, repository);
  testDeleteApplier(dbMock, repository);
  testGetApplier(dbMock, repository);
  testGetAppliers(dbMock, repository);
  testUpdateApplier(dbMock, repository);
}

void testCreateApplier(MockDatabase db, ApplierRepository repository) {
  group("createApplier function:", () {
    group('try to create a valid applier', () {
      setUp(() {
        when(db.insert(DatabaseApplierRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new applier entry and return its id", () async {
        final createdId = await repository.createApplier(_validApplier);

        expect(createdId, 1);
      });
    });
  });
}

void testDeleteApplier(MockDatabase db, ApplierRepository repository) {
  group("deleteApplier function:", () {
    group('try to delete valid applier', () {
      setUp(() {
        when(db.delete(
          DatabaseApplierRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validApplierId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a applier entry and returns 1", () async {
        final deletedCount = await repository.deleteApplier(_validApplierId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid applier', () {
      setUp(() {
        when(db.delete(
          DatabaseApplierRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_invalidApplierId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesnt exist", () async {
        final deletedCount = await repository.deleteApplier(_invalidApplierId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetApplier(MockDatabase db, ApplierRepository repository) {
  group("getApplier function:", () {
    final expectedApplier = _validApplier;

    group('try to get valid applier', () {
      setUp(() {
        when(db.query(
          DatabaseApplierRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validApplierId],
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedApplier.id,
                "cns": expectedApplier.cns,
                "person": expectedApplier.person.id,
                "establishment": expectedApplier.establishment.id,
              }
            ]));
      });

      test("should get a applier entry by its id", () async {
        final actualApplier = await repository.getApplierById(_validApplierId);

        expect(actualApplier, isA<Applier>());
        expect(actualApplier, expectedApplier);
      });
    });

    group('try to get an invalid applier', () {
      setUp(() {
        when(db.query(
          DatabaseApplierRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [2],
        )).thenAnswer((_) => Future.value([]));
      });

      test("should throw exception if id doesn't exist", () async {
        expect(
          () async => await repository.getApplierById(2),
          throwsStateError,
        );
      });
    });
  });
}

void testGetAppliers(MockDatabase db, ApplierRepository repository) {
  group("getAppliers function:", () {
    final expectedAppliers = _validAppliers;

    group('try to get all appliers', () {
      setUp(() {
        when(db.query(
          DatabaseApplierRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": expectedAppliers[0].id,
              "cns": expectedAppliers[0].cns,
              "person": expectedAppliers[0].person.id,
              "establishment": expectedAppliers[0].establishment.id,
            },
            {
              "id": expectedAppliers[1].id,
              "cns": expectedAppliers[1].cns,
              "person": expectedAppliers[1].person.id,
              "establishment": expectedAppliers[1].establishment.id,
            },
          ]),
        );
      });

      test("should return all appliers", () async {
        final actualAppliers = await repository.getAppliers();

        expect(actualAppliers, isA<List<Applier>>());
        for (int i = 0; i < actualAppliers.length; i++) {
          expect(actualAppliers[i], expectedAppliers[i]);
        }
      });
    });

    group('try to get all appliers when there is none', () {
      setUp(() {
        when(db.query(
          DatabaseApplierRepository.TABLE,
        )).thenAnswer((_) => Future.value([]));
      });

      test("should return an empty list", () async {
        final actualAppliers = await repository.getAppliers();

        expect(actualAppliers, isA<List<Applier>>());
        expect(actualAppliers, isEmpty);
      });
    });
  });
}

void testUpdateApplier(MockDatabase db, ApplierRepository repository) {
  group("updateApplier function:", () {
    group('try to update a valid applier', () {
      setUp(() {
        when(db.update(
          DatabaseApplierRepository.TABLE,
          _validApplier.copyWith(cns: "267174371730003").toMap(),
          where: anyNamed("where"),
          whereArgs: [_validApplierId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a applier entry and returns 1", () async {
        final createdId = await repository.updateApplier(
          _validApplier.copyWith(cns: "267174371730003"),
        );

        expect(createdId, 1);
      });
    });
    group('try to update with invalid applier', () {
      setUp(() {
        when(db.update(
          DatabaseApplierRepository.TABLE,
          _validApplier
              .copyWith(id: _invalidApplierId, cns: "267174371730003")
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [_invalidApplierId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updateApplier(
          _validApplier.copyWith(id: _invalidApplierId, cns: "267174371730003"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}

final int _validApplierId = 1;
final int _validPersonId = 1;
final int _validEstablishmentId = 1;
final int _validLocalityId = 1;

final int _invalidApplierId = 2;

final _validLocality = Locality(
  id: _validLocalityId,
  name: "Local",
  city: "Brasília",
  state: "DF",
  ibgeCode: "1234567",
);
final _validPerson = Person(
  id: _validPersonId,
  cpf: "73654421580",
  name: "Name Middlename Lastname",
  birthDate: DateTime(2000),
  locality: _validLocality,
);
final _validEstablishment = Establishment(
  id: _validEstablishmentId,
  cnes: "1234567",
  name: "Establishment Name",
  locality: _validLocality,
);
final _validApplier = Applier(
  id: _validApplierId,
  cns: "279197866950004",
  person: _validPerson,
  establishment: _validEstablishment,
);

final _validEstablishments = [
  _validEstablishment,
  _validEstablishment.copyWith(
    id: _validEstablishmentId + 1,
    cnes: "1234568",
    name: "Establishment Name 2",
  ),
  _validEstablishment.copyWith(
    id: _validEstablishmentId + 2,
    cnes: "1234569",
    name: "Establishment Name 3",
  ),
];

final _validPersons = [
  _validPerson,
  _validPerson.copyWith(
    id: _validPersonId + 1,
    cpf: "37346805739",
  ),
  _validPerson.copyWith(
    id: _validPersonId + 2,
    cpf: "47866147930",
  ),
];

final _validAppliers = [
  _validApplier,
  _validApplier.copyWith(
    id: _validApplierId + 1,
    cns: "104742903300006",
    person: _validPersons[1],
    establishment: _validEstablishments[2],
  ),
];
