import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_establishment_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabaseLocalityRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();

  final repository = DatabaseLocalityRepository(dbManager);

  setUp(() {
    when(dbManager.db).thenReturn(db);
  });

  testCreateLocality(db, dbManager, repository);
  // testDeleteLocality(db, dbManager, repository);
  // testGetLocality(db, dbManager, repository);
  // testGetLocalities(db, dbManager, repository);
  // testUpdateLocality(db, dbManager, repository);
}

void testCreateLocality(
  MockDatabase db,
  MockDatabaseManager dbManager,
  DatabaseLocalityRepository repository,
) {
  group("createLocality function:", () {
    final int validLocalityId = 1;
    final validLocality = Locality(
      validLocalityId,
      "Local",
      "Brasília",
      "DF",
      "IBGECode",
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

    group('try to create invalid locality', () {
      test("should throw exception if id is 0", () async {
        expect(
          () async => await repository.createLocality(
            validLocality.copyWith(id: 0),
          ),
          throwsException,
          reason: "it's not possible to create an locality with id 0",
        );
      });

      test("should throw exception if id is negative", () async {
        expect(
          () async => await repository.createLocality(
            validLocality.copyWith(id: -1),
          ),
          throwsException,
        );
      });

      test("should throw exception if name is empty", () async {
        expect(
          () async => await repository.createLocality(
            validLocality.copyWith(name: ""),
          ),
          throwsException,
        );
      });

      test("should throw exception if name has only spaces", () async {
        expect(
          () async => await repository.createLocality(
            validLocality.copyWith(name: "   "),
          ),
          throwsException,
        );
      });

      test("should throw exception if name has weird characters", () async {
        expect(
          () async => await repository.createLocality(
            validLocality.copyWith(
              name:
                  "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?",
            ),
          ),
          throwsException,
        );
      }, skip: true);

      test("should throw exception if city is empty", () async {
        expect(
          () async => await repository.createLocality(
            validLocality.copyWith(city: ""),
          ),
          throwsException,
        );
      });

      test("should throw exception if city has only spaces", () async {
        expect(
          () async => await repository.createLocality(
            validLocality.copyWith(city: "   "),
          ),
          throwsException,
        );
      });

      test("should throw exception if city has weird characters", () async {
        expect(
          () async => await repository.createLocality(
            validLocality.copyWith(
              city:
                  "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?",
            ),
          ),
          throwsException,
        );
      }, skip: true);

      test("should throw exception if state is empty", () async {
        expect(
          () async => await repository.createLocality(
            validLocality.copyWith(state: ""),
          ),
          throwsException,
        );
      });

      test("should throw exception if state has only spaces", () async {
        expect(
          () async => await repository.createLocality(
            validLocality.copyWith(state: "   "),
          ),
          throwsException,
        );
      });

      test("should throw exception if state has weird characters", () async {
        expect(
          () async => await repository.createLocality(
            validLocality.copyWith(
              state:
                  "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?",
            ),
          ),
          throwsException,
        );
      }, skip: true);
    });
  });
}

void testDeleteLocality(
  MockDatabase db,
  MockDatabaseManager dbManager,
  DatabaseLocalityRepository repository,
) {
  // group("deleteLocality function:", () {
  //   final int validLocalityId = 1;
  //   final int invalidLocalityId = 2;

  //   group('try to delete valid locality', () {
  //     setUp(() {
  //       when(db.delete(
  //         DatabaseLocalityRepository.TABLE,
  //         where: anyNamed("where"),
  //         whereArgs: [validLocalityId],
  //       )).thenAnswer((_) => Future.value(1));
  //     });

  //     test("should delete an locality entry and returns 1", () async {
  //       final deletedCount =
  //           await repository.deleteLocality(validLocalityId);

  //       expect(deletedCount, 1);
  //     });
  //   });

  //   group('try to delete invalid locality', () {
  //     setUp(() {
  //       when(db.delete(
  //         DatabaseLocalityRepository.TABLE,
  //         where: anyNamed("where"),
  //         whereArgs: [invalidLocalityId],
  //       )).thenAnswer((_) => Future.value(0));
  //     });

  //     test("should throw exception if id is 0", () async {
  //       expect(
  //         () async => await repository.deleteLocality(0),
  //         throwsException,
  //       );
  //     });

  //     test("should throw exception if id is negative", () async {
  //       expect(
  //         () async => await repository.deleteLocality(-1),
  //         throwsException,
  //       );
  //     });

  //     test("should return 0 if id doesnt exist", () async {
  //       final deletedCount =
  //           await repository.deleteLocality(invalidLocalityId);

  //       expect(deletedCount, 0);
  //     });
  //   });
  // });
}

void testGetLocality(
  MockDatabase db,
  MockDatabaseManager dbManager,
  DatabaseLocalityRepository repository,
) {
  // group("getLocality function:", () {
  //   final int validLocalityId = 1;
  //   final int validLocalityId = 1;
  //   final expectedLocality = Locality(
  //     validLocalityId,
  //     "Local",
  //     "Brasília",
  //     "DF",
  //     "IBGECode",
  //   );
  //   final expectedLocality = Locality(
  //     validLocalityId,
  //     "1234567",
  //     "Test",
  //     expectedLocality,
  //   );

  //   group('try to get valid locality', () {
  //     setUp(() {
  //       when(db.query(
  //         DatabaseLocalityRepository.TABLE,
  //         where: anyNamed("where"),
  //         whereArgs: [validLocalityId],
  //       )).thenAnswer((_) => Future.value([
  //             {
  //               "id": validLocalityId,
  //               "cnes": "1234567",
  //               "name": "Test",
  //               "locality": validLocalityId,
  //             }
  //           ]));
  //       when(db.query(
  //         DatabaseLocalityRepository.TABLE,
  //         where: anyNamed("where"),
  //         whereArgs: [validLocalityId],
  //       )).thenAnswer((_) => Future.value([
  //             {
  //               "id": validLocalityId,
  //               "name": "Local",
  //               "city": "Brasília",
  //               "state": "DF",
  //               "ibgeCode": "IBGECode",
  //             }
  //           ]));
  //     });

  //     test("should get an locality entry by its id", () async {
  //       final actualLocality =
  //           await repository.getLocalityById(validLocalityId);

  //       expect(actualLocality, isA<Locality>());
  //       expect(actualLocality, expectedLocality);
  //     });
  //   });

  //   group('try to get an invalid locality', () {
  //     setUp(() {
  //       when(db.query(
  //         DatabaseLocalityRepository.TABLE,
  //         where: anyNamed("where"),
  //         whereArgs: [anyOf(-1, 0, 2)],
  //       )).thenAnswer((_) => Future.value([]));
  //     });

  //     test("should throw exception if id is 0", () async {
  //       expect(
  //         () async => await repository.getLocalityById(0),
  //         throwsStateError,
  //       );
  //     });

  //     test("should throw exception if id is negative", () async {
  //       expect(
  //         () async => await repository.getLocalityById(-1),
  //         throwsStateError,
  //       );
  //     });

  //     test("should throw exception if id doesn't exist", () async {
  //       expect(
  //         () async => await repository.getLocalityById(2),
  //         throwsStateError,
  //       );
  //     });
  //   });
  // });
}

void testGetLocalities(
  MockDatabase db,
  MockDatabaseManager dbManager,
  DatabaseLocalityRepository repository,
) {
  // group("getLocalities function:", () {
  //   final int validLocalityId = 1;
  //   final int validLocalityId = 1;
  //   final expectedLocalities = [
  //     Locality(
  //       validLocalityId,
  //       "Local1",
  //       "Brasília",
  //       "DF",
  //       "IBGECode",
  //     ),
  //     Locality(
  //       validLocalityId + 1,
  //       "Local2",
  //       "Brasília",
  //       "DF",
  //       "IBGECode",
  //     ),
  //     Locality(
  //       validLocalityId + 2,
  //       "Local3",
  //       "Brasília",
  //       "DF",
  //       "IBGECode",
  //     ),
  //   ];
  //   final expectedLocalities = [
  //     Locality(
  //       validLocalityId,
  //       "1234567",
  //       "Test",
  //       expectedLocalities[0],
  //     ),
  //     Locality(
  //       validLocalityId + 1,
  //       "1234568",
  //       "Test2",
  //       expectedLocalities[1],
  //     ),
  //   ];

  //   group('try to get all localities', () {
  //     setUp(() {
  //       when(db.query(
  //         DatabaseLocalityRepository.TABLE,
  //       )).thenAnswer((_) => Future.value([
  //             {
  //               "id": validLocalityId,
  //               "cnes": "1234567",
  //               "name": "Test",
  //               "locality": validLocalityId,
  //             },
  //             {
  //               "id": validLocalityId + 1,
  //               "cnes": "1234568",
  //               "name": "Test2",
  //               "locality": validLocalityId + 1,
  //             },
  //           ]));
  //       when(db.query(
  //         DatabaseLocalityRepository.TABLE,
  //       )).thenAnswer((_) => Future.value([
  //             {
  //               "id": validLocalityId,
  //               "name": "Local1",
  //               "city": "Brasília",
  //               "state": "DF",
  //               "ibgeCode": "IBGECode",
  //             },
  //             {
  //               "id": validLocalityId + 1,
  //               "name": "Local2",
  //               "city": "Brasília",
  //               "state": "DF",
  //               "ibgeCode": "IBGECode",
  //             },
  //             {
  //               "id": validLocalityId + 2,
  //               "name": "Local3",
  //               "city": "Brasília",
  //               "state": "DF",
  //               "ibgeCode": "IBGECode",
  //             },
  //           ]));
  //     });

  //     test("should return all localities", () async {
  //       final actualLocalities = await repository.getLocalities();

  //       expect(actualLocalities, isA<List<Locality>>());
  //       for (int i = 0; i < actualLocalities.length; i++) {
  //         expect(actualLocalities[i], expectedLocalities[i]);
  //       }
  //     });
  //   });

  //   group('try to get all localities when there is none', () {
  //     setUp(() {
  //       when(db.query(
  //         DatabaseLocalityRepository.TABLE,
  //       )).thenAnswer((_) => Future.value([]));
  //     });

  //     test("should return an empty list", () async {
  //       final actualLocalities = await repository.getLocalities();

  //       expect(actualLocalities, isA<List<Locality>>());
  //       expect(actualLocalities, isEmpty);
  //     });
  //   });
  // });
}

void testUpdateLocality(
  MockDatabase db,
  MockDatabaseManager dbManager,
  DatabaseLocalityRepository repository,
) {
  // group("updateLocality function:", () {
  //   final int validLocalityId = 1;
  //   final expectedLocality = Locality(
  //     validLocalityId,
  //     "Local",
  //     "Brasília",
  //     "DF",
  //     "IBGECode",
  //   );

  //   group('try to update a valid locality', () {
  //     setUp(() {
  //       when(db.update(
  //         DatabaseLocalityRepository.TABLE,
  //         validLocality.copyWith(name: "Updated").toMap(),
  //         where: anyNamed("where"),
  //         whereArgs: [validLocalityId],
  //       )).thenAnswer((_) => Future.value(1));
  //     });

  //     test("should update a locality entry and returns 1", () async {
  //       final createdId = await repository.updateLocality(
  //         validLocality.copyWith(name: "Updated"),
  //       );

  //       expect(createdId, 1);
  //     });
  //   });
  //   group('try to update with invalid locality', () {
  //     test("should throw exception if id is 0", () async {
  //       expect(
  //         () async => await repository.updateLocality(
  //           validLocality.copyWith(id: 0),
  //         ),
  //         throwsException,
  //         reason: "there is no locality with id 0",
  //       );
  //     });

  //     test("should throw exception if id is negative", () async {
  //       expect(
  //         () async => await repository.updateLocality(
  //           validLocality.copyWith(id: -1),
  //         ),
  //         throwsException,
  //         reason: "there is no locality with negative id",
  //       );
  //     });

  //     test("should throw exception if cnes length != 7", () async {
  //       expect(
  //         () async => await repository.updateLocality(
  //           validLocality.copyWith(cnes: "123456"),
  //         ),
  //         throwsException,
  //       );

  //       expect(
  //         () async => await repository.updateLocality(
  //           validLocality.copyWith(cnes: " 23456 "),
  //         ),
  //         throwsException,
  //       );

  //       expect(
  //         () async => await repository.updateLocality(
  //           validLocality.copyWith(cnes: "123456789"),
  //         ),
  //         throwsException,
  //       );
  //     });

  //     test("should throw exception if cnes has no numeric characters",
  //         () async {
  //       expect(
  //         () async => await repository.updateLocality(
  //           validLocality.copyWith(cnes: "123456A"),
  //         ),
  //         throwsException,
  //       );

  //       expect(
  //         () async => await repository.updateLocality(
  //           validLocality.copyWith(cnes: "12 45 7"),
  //         ),
  //         throwsException,
  //       );
  //     });

  //     test("should throw exception if name is empty", () async {
  //       expect(
  //         () async => await repository.updateLocality(
  //           validLocality.copyWith(name: ""),
  //         ),
  //         throwsException,
  //       );
  //     });

  //     test("should throw exception if name has only spaces", () async {
  //       expect(
  //         () async => await repository.updateLocality(
  //           validLocality.copyWith(name: "   "),
  //         ),
  //         throwsException,
  //       );
  //     });

  //     test("should throw exception if name has weird characters", () async {
  //       expect(
  //         () async => await repository.updateLocality(
  //           validLocality.copyWith(
  //             name:
  //                 "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?",
  //           ),
  //         ),
  //         throwsException,
  //       );
  //     }, skip: true);
  //   });
  // });
}
