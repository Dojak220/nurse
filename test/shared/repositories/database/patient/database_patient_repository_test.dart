import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/patient/database_patient_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_patient_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabasePatientRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();

  final repository = DatabasePatientRepository(dbManager);

  setUp(() {
    when(dbManager.db).thenReturn(db);
  });

  testCreatePatient(db, repository);
  // testDeletePatient(db, repository);
  // testGetPatient(db, repository);
  // testGetPatients(db, repository);
  // testUpdatePatient(db, repository);
}

void testCreatePatient(
  MockDatabase db,
  DatabasePatientRepository repository,
) {
  group("createPatient function:", () {
    final int validPatientId = 1;
    final int validPriorityGroupId = 1;
    final int validLocalityId = 1;

    final expectedPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      groupCode: "",
      name: "",
      description: "",
    );

    final expectedLocality = Locality(
      validLocalityId,
      "Local",
      "Brasília",
      "DF",
      "IBGECode",
    );

    final validPatient = Patient(
      id: validPatientId,
      cns: "138068523490004",
      maternalCondition: MaternalCondition.GESTANTE,
      priorityGroup: expectedPriorityGroup,
      person: Person(
        id: validPatientId,
        cpf: "44407857862",
        name: "Teste",
        birthDate: DateTime(2000),
        locality: expectedLocality,
        gender: Gender.MALE,
        motherName: "Mãe",
        fatherName: "Pai",
      ),
    );

    group('try to create a valid patient', () {
      setUp(() {
        when(db.insert(any, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new patient entry and return its id", () async {
        final createdId = await repository.createPatient(validPatient);

        expect(createdId, 1);
      });
    });

    group('try to create invalid patient', () {
      test("should throw exception if id is 0", () async {
        expect(
          () async => await repository.createPatient(
            validPatient.copyWith(id: 0),
          ),
          throwsException,
          reason: "it's not possible to create an patient with id 0",
        );
      });

      test("should throw exception if id is negative", () async {
        expect(
          () async => await repository.createPatient(
            validPatient.copyWith(id: -1),
          ),
          throwsException,
        );
      });

      test("should throw exception if cns length != 15", () async {
        expect(
          () async => await repository.createPatient(
            validPatient.copyWith(cns: "12345678901234"),
          ),
          throwsException,
        );

        expect(
          () async => await repository.createPatient(
            validPatient.copyWith(cns: " 2345678901234 "),
          ),
          throwsException,
        );

        expect(
          () async => await repository.createPatient(
            validPatient.copyWith(cns: "1234567890123456"),
          ),
          throwsException,
        );
      });

      test("should throw exception if cns has no numeric characters", () async {
        expect(
          () async => await repository.createPatient(
            validPatient.copyWith(cns: "12345678901234A"),
          ),
          throwsException,
        );

        expect(
          () async => await repository.createPatient(
            validPatient.copyWith(cns: "12 45 7890 2 45"),
          ),
          throwsException,
        );

        expect(
          () async => await repository.createPatient(
            validPatient.copyWith(cns: "1-3/%6789_12+4*"),
          ),
          throwsException,
        );
      });

      test("should throw exception if cns is 0 * 15", () async {
        expect(
          () async => await repository.createPatient(
            validPatient.copyWith(cns: "0" * 15),
          ),
          throwsException,
        );
      });
    });
  });
}

void testDeletePatient(
  MockDatabase db,
  MockDatabaseManager dbManager,
  DatabasePatientRepository repository,
) {
//   group("deletePatient function:", () {
//     final int validPatientId = 1;
//     final int invalidPatientId = 2;

//     group('try to delete valid patient', () {
//       setUp(() {
//         when(db.delete(
//           DatabasePatientRepository.TABLE,
//           where: anyNamed("where"),
//           whereArgs: [validPatientId],
//         )).thenAnswer((_) => Future.value(1));
//       });

//       test("should delete an patient entry and returns 1", () async {
//         final deletedCount =
//             await repository.deletePatient(validPatientId);

//         expect(deletedCount, 1);
//       });
//     });

//     group('try to delete invalid patient', () {
//       setUp(() {
//         when(db.delete(
//           DatabasePatientRepository.TABLE,
//           where: anyNamed("where"),
//           whereArgs: [invalidPatientId],
//         )).thenAnswer((_) => Future.value(0));
//       });

//       test("should throw exception if id is 0", () async {
//         expect(
//           () async => await repository.deletePatient(0),
//           throwsException,
//         );
//       });

//       test("should throw exception if id is negative", () async {
//         expect(
//           () async => await repository.deletePatient(-1),
//           throwsException,
//         );
//       });

//       test("should return 0 if id doesnt exist", () async {
//         final deletedCount =
//             await repository.deletePatient(invalidPatientId);

//         expect(deletedCount, 0);
//       });
//     });
//   });
}

// void testGetPatient(
//   MockDatabase db,
//   MockDatabaseManager dbManager,
//   DatabasePatientRepository repository,
// ) {
//   group("getPatient function:", () {
//     final int validPatientId = 1;
//     final int validLocalityId = 1;
//     final expectedLocality = Locality(
//       validLocalityId,
//       "Local",
//       "Brasília",
//       "DF",
//       "IBGECode",
//     );
//     final expectedPatient = Patient(
//       validPatientId,
//       "1234567",
//       "Test",
//       expectedLocality,
//     );

//     group('try to get valid patient', () {
//       setUp(() {
//         when(db.query(
//           DatabasePatientRepository.TABLE,
//           where: anyNamed("where"),
//           whereArgs: [validPatientId],
//         )).thenAnswer((_) => Future.value([
//               {
//                 "id": validPatientId,
//                 "cnes": "1234567",
//                 "name": "Test",
//                 "locality": validLocalityId,
//               }
//             ]));
//         when(db.query(
//           DatabaseLocalityRepository.TABLE,
//           where: anyNamed("where"),
//           whereArgs: [validLocalityId],
//         )).thenAnswer((_) => Future.value([
//               {
//                 "id": validLocalityId,
//                 "name": "Local",
//                 "city": "Brasília",
//                 "state": "DF",
//                 "ibgeCode": "IBGECode",
//               }
//             ]));
//       });

//       test("should get an patient entry by its id", () async {
//         final actualPatient =
//             await repository.getEstaPatient(validPatientId);

//         expect(actualPatient, isA<Patient>());
//         expect(actualPatient, expectedPatient);
//       });
//     });

//     group('try to get an invalid patient', () {
//       setUp(() {
//         when(db.query(
//           DatabasePatientRepository.TABLE,
//           where: anyNamed("where"),
//           whereArgs: [anyOf(-1, 0, 2)],
//         )).thenAnswer((_) => Future.value([]));
//       });

//       test("should throw exception if id is 0", () async {
//         expect(
//           () async => await repository.getEstaPatient(0),
//           throwsStateError,
//         );
//       });

//       test("should throw exception if id is negative", () async {
//         expect(
//           () async => await repository.getEstaPatient(-1),
//           throwsStateError,
//         );
//       });

//       test("should throw exception if id doesn't exist", () async {
//         expect(
//           () async => await repository.getEstaPatient(2),
//           throwsStateError,
//         );
//       });
//     });
//   });
// }

// void testGetPatients(
//   MockDatabase db,
//   MockDatabaseManager dbManager,
//   DatabasePatientRepository repository,
// ) {
//   group("getPatients function:", () {
//     final int validLocalityId = 1;
//     final int validPatientId = 1;
//     final expectedLocalities = [
//       Locality(
//         validLocalityId,
//         "Local1",
//         "Brasília",
//         "DF",
//         "IBGECode",
//       ),
//       Locality(
//         validLocalityId + 1,
//         "Local2",
//         "Brasília",
//         "DF",
//         "IBGECode",
//       ),
//       Locality(
//         validLocalityId + 2,
//         "Local3",
//         "Brasília",
//         "DF",
//         "IBGECode",
//       ),
//     ];
//     final expectedPatients = [
//       Patient(
//         validPatientId,
//         "1234567",
//         "Test",
//         expectedLocalities[0],
//       ),
//       Patient(
//         validPatientId + 1,
//         "1234568",
//         "Test2",
//         expectedLocalities[1],
//       ),
//     ];

//     group('try to get all patients', () {
//       setUp(() {
//         when(db.query(
//           DatabasePatientRepository.TABLE,
//         )).thenAnswer((_) => Future.value([
//               {
//                 "id": validPatientId,
//                 "cnes": "1234567",
//                 "name": "Test",
//                 "locality": validLocalityId,
//               },
//               {
//                 "id": validPatientId + 1,
//                 "cnes": "1234568",
//                 "name": "Test2",
//                 "locality": validLocalityId + 1,
//               },
//             ]));
//         when(db.query(
//           DatabaseLocalityRepository.TABLE,
//         )).thenAnswer((_) => Future.value([
//               {
//                 "id": validLocalityId,
//                 "name": "Local1",
//                 "city": "Brasília",
//                 "state": "DF",
//                 "ibgeCode": "IBGECode",
//               },
//               {
//                 "id": validLocalityId + 1,
//                 "name": "Local2",
//                 "city": "Brasília",
//                 "state": "DF",
//                 "ibgeCode": "IBGECode",
//               },
//               {
//                 "id": validLocalityId + 2,
//                 "name": "Local3",
//                 "city": "Brasília",
//                 "state": "DF",
//                 "ibgeCode": "IBGECode",
//               },
//             ]));
//       });

//       test("should return all patients", () async {
//         final actualPatients = await repository.getEPatient();

//         expect(actualPatients, isA<List<Patient>>());
//         for (int i = 0; i < actualPatients.length; i++) {
//           expect(actualPatients[i], expectedPatients[i]);
//         }
//       });
//     });

//     group('try to get all patients when there is none', () {
//       setUp(() {
//         when(db.query(
//           DatabasePatientRepository.TABLE,
//         )).thenAnswer((_) => Future.value([]));
//       });

//       test("should return an empty list", () async {
//         final actualPatients = await repository.getEPatient();

//         expect(actualPatients, isA<List<Patient>>());
//         expect(actualPatients, isEmpty);
//       });
//     });
//   });
// }

// void testUpdatePatient(
//   MockDatabase db,
//   MockDatabaseManager dbManager,
//   DatabasePatientRepository repository,
// ) {
//   group("updatePatient function:", () {
//     final int validPatientId = 1;
//     final int validLocalityId = 1;
//     final expectedLocality = Locality(
//       validLocalityId,
//       "Local",
//       "Brasília",
//       "DF",
//       "IBGECode",
//     );
//     final validPatient = Patient(
//       validPatientId,
//       "1234567",
//       "Old Name",
//       expectedLocality,
//     );

//     group('try to update a valid patient', () {
//       setUp(() {
//         when(db.update(
//           DatabasePatientRepository.TABLE,
//           validPatient.copyWith(name: "Updated").toMap(),
//           where: anyNamed("where"),
//           whereArgs: [validPatientId],
//         )).thenAnswer((_) => Future.value(1));
//       });

//       test("should update a patient entry and returns 1", () async {
//         final createdId = await repository.updatePatient(
//           validPatient.copyWith(name: "Updated"),
//         );

//         expect(createdId, 1);
//       });
//     });
//     group('try to update with invalid patient', () {
//       test("should throw exception if id is 0", () async {
//         expect(
//           () async => await repository.updatePatient(
//             validPatient.copyWith(id: 0),
//           ),
//           throwsException,
//           reason: "there is no patient with id 0",
//         );
//       });

//       test("should throw exception if id is negative", () async {
//         expect(
//           () async => await repository.updatePatient(
//             validPatient.copyWith(id: -1),
//           ),
//           throwsException,
//           reason: "there is no patient with negative id",
//         );
//       });

//       test("should throw exception if cnes length != 7", () async {
//         expect(
//           () async => await repository.updatePatient(
//             validPatient.copyWith(cnes: "123456"),
//           ),
//           throwsException,
//         );

//         expect(
//           () async => await repository.updatePatient(
//             validPatient.copyWith(cnes: " 23456 "),
//           ),
//           throwsException,
//         );

//         expect(
//           () async => await repository.updatePatient(
//             validPatient.copyWith(cnes: "123456789"),
//           ),
//           throwsException,
//         );
//       });

//       test("should throw exception if cnes has no numeric characters",
//           () async {
//         expect(
//           () async => await repository.updatePatient(
//             validPatient.copyWith(cnes: "123456A"),
//           ),
//           throwsException,
//         );

//         expect(
//           () async => await repository.updatePatient(
//             validPatient.copyWith(cnes: "12 45 7"),
//           ),
//           throwsException,
//         );
//       });

//       test("should throw exception if name is empty", () async {
//         expect(
//           () async => await repository.updatePatient(
//             validPatient.copyWith(name: ""),
//           ),
//           throwsException,
//         );
//       });

//       test("should throw exception if name has only spaces", () async {
//         expect(
//           () async => await repository.updatePatient(
//             validPatient.copyWith(name: "   "),
//           ),
//           throwsException,
//         );
//       });

//       test("should throw exception if name has weird characters", () async {
//         expect(
//           () async => await repository.updatePatient(
//             validPatient.copyWith(
//               name:
//                   "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?",
//             ),
//           ),
//           throwsException,
//         );
//       }, skip: true);
//     });
//   });
// }
