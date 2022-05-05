import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_person_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_applier_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_applier_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabaseApplierRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();

  final repository = DatabaseApplierRepository(dbManager);

  setUp(() {
    when(dbManager.db).thenReturn(db);
  });

  testCreateApplier(db, repository);
  testDeleteApplier(db, repository);
  testGetApplier(db, repository);
  testGetAppliers(db, repository);
  testUpdateApplier(db, repository);
}

void testCreateApplier(
  MockDatabase db,
  DatabaseApplierRepository repository,
) {
  group("createApplier function:", () {
    final int validApplierId = 1;
    final int validPersonId = 1;
    final int validEstablishmentId = 1;
    final int validLocalityId = 1;

    final validLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );
    final validPerson = Person(
      id: validPersonId,
      cpf: "73654421580",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: validLocality,
    );
    final validEstablishment = Establishment(
      id: validEstablishmentId,
      cnes: "1234567",
      name: "Establishment Name",
      locality: validLocality,
    );
    final expectedApplier = Applier(
      id: validApplierId,
      cns: "279197866950004",
      person: validPerson,
      establishment: validEstablishment,
    );

    group('try to create a valid applier', () {
      setUp(() {
        when(db.insert(DatabaseApplierRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new applier entry and return its id", () async {
        final createdId = await repository.createApplier(expectedApplier);

        expect(createdId, 1);
      });
    });
  });
}

void testDeleteApplier(
  MockDatabase db,
  DatabaseApplierRepository repository,
) {
  group("deleteApplier function:", () {
    final int validApplierId = 1;
    final int invalidApplierId = 2;

    group('try to delete valid applier', () {
      setUp(() {
        when(db.delete(
          DatabaseApplierRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validApplierId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a applier entry and returns 1", () async {
        final deletedCount = await repository.deleteApplier(validApplierId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid applier', () {
      setUp(() {
        when(db.delete(
          DatabaseApplierRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [invalidApplierId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesnt exist", () async {
        final deletedCount = await repository.deleteApplier(invalidApplierId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetApplier(
  MockDatabase db,
  DatabaseApplierRepository repository,
) {
  group("getApplier function:", () {
    final int validApplierId = 1;
    final int validPersonId = 1;
    final int validEstablishmentId = 1;
    final int validLocalityId = 1;

    final validLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );
    final validPerson = Person(
      id: validPersonId,
      cpf: "73654421580",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: validLocality,
    );
    final validEstablishment = Establishment(
      id: validEstablishmentId,
      cnes: "1234567",
      name: "Establishment Name",
      locality: validLocality,
    );
    final expectedApplier = Applier(
      id: validApplierId,
      cns: "279197866950004",
      person: validPerson,
      establishment: validEstablishment,
    );

    group('try to get valid applier', () {
      setUp(() {
        when(db.query(
          DatabaseApplierRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validApplierId],
        )).thenAnswer((_) => Future.value([
              {
                'id': expectedApplier.id,
                'cns': expectedApplier.cns,
                'person': expectedApplier.person.id,
                'establishment': expectedApplier.establishment.id,
              }
            ]));

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
              "birth_date": validPerson.birthDate.millisecondsSinceEpoch,
              "locality": validPerson.locality.id,
            }
          ]),
        );

        when(db.query(
          DatabaseEstablishmentRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validEstablishmentId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validEstablishment.id,
              "cnes": validEstablishment.cnes,
              "name": validEstablishment.name,
              "locality": validEstablishment.locality.id,
            }
          ]),
        );
      });

      test("should get a applier entry by its id", () async {
        final actualApplier = await repository.getApplierById(validApplierId);

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

void testGetAppliers(
  MockDatabase db,
  DatabaseApplierRepository repository,
) {
  group("getAppliers function:", () {
    final int validApplierId = 1;
    final int validPersonId = 1;
    final int validEstablishmentId = 1;
    final int validLocalityId = 1;

    final validLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );
    final validPerson = Person(
      id: validPersonId,
      cpf: "73654421580",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: validLocality,
    );
    final validEstablishment = Establishment(
      id: validEstablishmentId,
      cnes: "1234567",
      name: "Establishment Name",
      locality: validLocality,
    );
    final expectedApplier = Applier(
      id: validApplierId,
      cns: "279197866950004",
      person: validPerson,
      establishment: validEstablishment,
    );

    final validLocalities = [
      validLocality,
      validLocality.copyWith(
        id: validLocalityId + 1,
        name: "Local 2",
        ibgeCode: "1234568",
      ),
      validLocality.copyWith(
        id: validLocalityId + 2,
        name: "Local 3",
        ibgeCode: "1234569",
      ),
    ];

    final validEstablishments = [
      validEstablishment,
      validEstablishment.copyWith(
        id: validEstablishmentId + 1,
        cnes: "1234568",
        name: "Establishment Name 2",
      ),
      validEstablishment.copyWith(
        id: validEstablishmentId + 2,
        cnes: "1234569",
        name: "Establishment Name 3",
      ),
    ];

    final validPersons = [
      validPerson,
      validPerson.copyWith(
        id: validPersonId + 1,
        cpf: "37346805739",
      ),
      validPerson.copyWith(
        id: validPersonId + 2,
        cpf: "47866147930",
      ),
    ];

    final expectedAppliers = [
      expectedApplier,
      expectedApplier.copyWith(
        id: validApplierId + 1,
        cns: "104742903300006",
        person: validPersons[1],
        establishment: validEstablishments[2],
      ),
    ];

    group('try to get all appliers', () {
      setUp(() {
        when(db.query(
          DatabaseApplierRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              'id': expectedAppliers[0].id,
              'cns': expectedAppliers[0].cns,
              'person': expectedAppliers[0].person.id,
              'establishment': expectedAppliers[0].establishment.id,
            },
            {
              'id': expectedAppliers[1].id,
              'cns': expectedAppliers[1].cns,
              'person': expectedAppliers[1].person.id,
              'establishment': expectedAppliers[1].establishment.id,
            },
          ]),
        );

        when(db.query(
          DatabaseLocalityRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validLocalities[0].id,
              "name": validLocalities[0].name,
              "city": validLocalities[0].city,
              "state": validLocalities[0].state,
              "ibge_code": validLocalities[0].ibgeCode,
            },
            {
              "id": validLocalities[1].id,
              "name": validLocalities[1].name,
              "city": validLocalities[1].city,
              "state": validLocalities[1].state,
              "ibge_code": validLocalities[1].ibgeCode,
            },
            {
              "id": validLocalities[2].id,
              "name": validLocalities[2].name,
              "city": validLocalities[2].city,
              "state": validLocalities[2].state,
              "ibge_code": validLocalities[2].ibgeCode,
            },
          ]),
        );

        when(db.query(
          DatabasePersonRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validPersons[0].id,
              "cpf": validPersons[0].cpf,
              "name": validPersons[0].name,
              "birth_date": validPersons[0].birthDate.millisecondsSinceEpoch,
              "locality": validPersons[0].locality.id,
            },
            {
              "id": validPersons[1].id,
              "cpf": validPersons[1].cpf,
              "name": validPersons[1].name,
              "birth_date": validPersons[1].birthDate.millisecondsSinceEpoch,
              "locality": validPersons[1].locality.id,
            },
            {
              "id": validPersons[2].id,
              "cpf": validPersons[2].cpf,
              "name": validPersons[2].name,
              "birth_date": validPersons[2].birthDate.millisecondsSinceEpoch,
              "locality": validPersons[2].locality.id,
            },
          ]),
        );

        when(db.query(
          DatabaseEstablishmentRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": validEstablishments[0].id,
              "cnes": validEstablishments[0].cnes,
              "name": validEstablishments[0].name,
              "locality": validEstablishments[0].locality.id,
            },
            {
              "id": validEstablishments[1].id,
              "cnes": validEstablishments[1].cnes,
              "name": validEstablishments[1].name,
              "locality": validEstablishments[1].locality.id,
            },
            {
              "id": validEstablishments[2].id,
              "cnes": validEstablishments[2].cnes,
              "name": validEstablishments[2].name,
              "locality": validEstablishments[2].locality.id,
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

void testUpdateApplier(
  MockDatabase db,
  DatabaseApplierRepository repository,
) {
  final int invalidApplierId = 2;
  group("updateApplier function:", () {
    final int validApplierId = 1;
    final int validPersonId = 1;
    final int validEstablishmentId = 1;
    final int validLocalityId = 1;

    final validLocality = Locality(
      id: validLocalityId,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );

    final validPerson = Person(
      id: validPersonId,
      cpf: "73654421580",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: validLocality,
    );

    final validEstablishment = Establishment(
      id: validEstablishmentId,
      cnes: "1234567",
      name: "Establishment Name",
      locality: validLocality,
    );

    final validApplier = Applier(
      id: validApplierId,
      cns: "279197866950004",
      person: validPerson,
      establishment: validEstablishment,
    );

    group('try to update a valid applier', () {
      setUp(() {
        when(db.update(
          DatabaseApplierRepository.TABLE,
          validApplier.copyWith(cns: "267174371730003").toMap(),
          where: anyNamed("where"),
          whereArgs: [validApplierId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a applier entry and returns 1", () async {
        final createdId = await repository.updateApplier(
          validApplier.copyWith(cns: "267174371730003"),
        );

        expect(createdId, 1);
      });
    });
    group('try to update with invalid applier', () {
      setUp(() {
        when(db.update(
          DatabaseApplierRepository.TABLE,
          validApplier
              .copyWith(id: invalidApplierId, cns: "267174371730003")
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [invalidApplierId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updateApplier(
          validApplier.copyWith(id: invalidApplierId, cns: "267174371730003"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}
