import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_establishment_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabaseEstablishmentRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();

  final repository = DatabaseEstablishmentRepository(dbManager);

  testCreateEstablishment(db, dbManager, repository);
  testDeleteEstablishment(db, dbManager, repository);
  // TODO: testGetEstablishment(db, dbManager, repository);
  // TODO: testGetEstablishments(db, dbManager, repository);
  // TODO: testUpdateEstablishment(db, dbManager, repository);
}

void testCreateEstablishment(
  MockDatabase db,
  MockDatabaseManager dbManager,
  DatabaseEstablishmentRepository repository,
) {
  final validEstablishment = Establishment(
    1,
    "1234567",
    "Test",
    Locality(1, "Nome da localidade", "Brasília", "DF", "IBGECode"),
  );
  group('create valid establishment', () {
    setUp(() {
      when(dbManager.db).thenReturn(db);
      when(db.insert(any, any,
              conflictAlgorithm: anyNamed("conflictAlgorithm")))
          .thenAnswer((_) => Future.value(1));
    });

    test('should create a new establishment entry and return its id', () async {
      final createdId =
          await repository.createEstablishment(validEstablishment);

      expect(createdId, 1);
    });
  });
  group('try to create invalid establishment', () {
    test('should return exception if id is 0', () async {
      expect(
        () async => await repository.createEstablishment(
          validEstablishment.copyWith(id: 0),
        ),
        throwsException,
      );
    });

    test('should return exception if id is negative', () async {
      expect(
        () async => await repository.createEstablishment(
          validEstablishment.copyWith(id: -1),
        ),
        throwsException,
      );
    });

    test('should return exception if cnes length != 7', () async {
      expect(
        () async => await repository.createEstablishment(
          validEstablishment.copyWith(cnes: "123456"),
        ),
        throwsException,
      );

      expect(
        () async => await repository.createEstablishment(
          validEstablishment.copyWith(cnes: " 23456 "),
        ),
        throwsException,
      );

      expect(
        () async => await repository.createEstablishment(
          validEstablishment.copyWith(cnes: "123456789"),
        ),
        throwsException,
      );
    });

    test('should return exception if cnes has not numbers characters',
        () async {
      expect(
        () async => await repository.createEstablishment(
          validEstablishment.copyWith(cnes: "123456A"),
        ),
        throwsException,
      );

      expect(
        () async => await repository.createEstablishment(
          validEstablishment.copyWith(cnes: "12 45 7"),
        ),
        throwsException,
      );
    });

    test('should return exception if name is empty', () async {
      expect(
        () async => await repository.createEstablishment(
          validEstablishment.copyWith(name: ""),
        ),
        throwsException,
      );
    });

    test('should return exception if name has only spaces', () async {
      expect(
        () async => await repository.createEstablishment(
          validEstablishment.copyWith(name: "   "),
        ),
        throwsException,
      );
    });

    test('should return exception if name has weird characters', () async {
      expect(
        () async => await repository.createEstablishment(
          validEstablishment.copyWith(
            name: "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?",
          ),
        ),
        throwsException,
      );
    }, skip: true);
  });
}

void testDeleteEstablishment(
  MockDatabase db,
  MockDatabaseManager dbManager,
  DatabaseEstablishmentRepository repository,
) {
  final int validEstablishmentId = 1;
  final int invalidEstablishmentId = 2;

  group('create valid establishment', () {
    setUp(() {
      when(dbManager.db).thenReturn(db);
      when(db.delete(
        DatabaseEstablishmentRepository.TABLE,
        where: anyNamed("where"),
        whereArgs: [validEstablishmentId],
      )).thenAnswer((_) => Future.value(1));
    });

    test('should create a new establishment entry and return its id', () async {
      final deletedCount =
          await repository.deleteEstablishment(validEstablishmentId);

      expect(deletedCount, 1);
    });
  });

  group('try to delete invalid establishment', () {
    setUp(() {
      when(dbManager.db).thenReturn(db);
      when(db.delete(
        DatabaseEstablishmentRepository.TABLE,
        where: anyNamed("where"),
        whereArgs: [invalidEstablishmentId],
      )).thenAnswer((_) => Future.value(0));
    });

    test('should return exception if id is 0', () async {
      expect(
        () async => await repository.deleteEstablishment(0),
        throwsException,
      );
    });

    test('should return exception if id is negative', () async {
      expect(
        () async => await repository.deleteEstablishment(-1),
        throwsException,
      );
    });

    test('should return 0 if id doesnt exist', () async {
      final deletedCount =
          await repository.deleteEstablishment(invalidEstablishmentId);

      expect(deletedCount, 0);
    });
  });
}

void testGetEstablishment(
  MockDatabase db,
  MockDatabaseManager dbManager,
  DatabaseEstablishmentRepository repository,
) {}

void testGetEstablishments(
  MockDatabase db,
  MockDatabaseManager dbManager,
  DatabaseEstablishmentRepository repository,
) {}

void testUpdateEstablishment(
  MockDatabase db,
  MockDatabaseManager dbManager,
  DatabaseEstablishmentRepository repository,
) {}
