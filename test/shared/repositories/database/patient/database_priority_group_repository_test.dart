import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_priority_group_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabasePriorityGroupRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();
  final repository = DatabasePriorityGroupRepository(dbManager);

  setUp(() {
    when(dbManager.db).thenReturn(db);
  });

  testCreatePriorityGroup(db, repository);
  testDeletePriorityGroup(db, repository);
  testGetPriorityGroup(db, repository);
  testGetPriorityGroups(db, repository);
  testUpdatePriorityGroup(db, repository);
}

void testCreatePriorityGroup(
  MockDatabase db,
  DatabasePriorityGroupRepository repository,
) {
  group("createPriorityGroup function:", () {
    final int validPriorityGroupId = 1;

    final validPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      code: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    group('try to create a valid priorityGroup', () {
      setUp(() {
        when(db.insert(DatabasePriorityGroupRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new priorityGroup entry and return its id",
          () async {
        final createdId =
            await repository.createPriorityGroup(validPriorityGroup);

        expect(createdId, 1);
      });
    });
  });
}

void testDeletePriorityGroup(
  MockDatabase db,
  DatabasePriorityGroupRepository repository,
) {
  group("deletePriorityGroup function:", () {
    final int validPriorityGroupId = 1;
    final int invalidPriorityGroupId = 2;

    group('try to delete valid priorityGroup', () {
      setUp(() {
        when(db.delete(
          DatabasePriorityGroupRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPriorityGroupId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a priorityGroup entry and returns 1", () async {
        final deletedCount =
            await repository.deletePriorityGroup(validPriorityGroupId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid priorityGroup', () {
      setUp(() {
        when(db.delete(
          DatabasePriorityGroupRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [invalidPriorityGroupId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final deletedCount =
            await repository.deletePriorityGroup(invalidPriorityGroupId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetPriorityGroup(
  MockDatabase db,
  DatabasePriorityGroupRepository repository,
) {
  group("getPriorityGroup function:", () {
    final int validPriorityGroupId = 1;
    final int invalidPriorityGroupId = 2;
    final expectedPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      code: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    group('try to get valid priorityGroup', () {
      setUp(() {
        when(db.query(
          DatabasePriorityGroupRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPriorityGroupId],
        )).thenAnswer(
          (_) => Future.value([
            {
              'id': expectedPriorityGroup.id,
              'code': expectedPriorityGroup.code,
              'name': expectedPriorityGroup.name,
              'description': expectedPriorityGroup.description,
            }
          ]),
        );
      });

      test("should get a priorityGroup entry by its id", () async {
        final actualPriorityGroup =
            await repository.getPriorityGroupById(validPriorityGroupId);

        expect(actualPriorityGroup, isA<PriorityGroup>());
        expect(actualPriorityGroup, expectedPriorityGroup);
      });
    });

    group('try to get an invalid priorityGroup', () {
      setUp(() {
        when(db.query(
          DatabasePriorityGroupRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [invalidPriorityGroupId],
        )).thenAnswer((_) => Future.value([]));
      });

      test("should throw exception if id doesn't exist", () async {
        expect(
          () async => await repository.getPriorityGroupById(2),
          throwsStateError,
        );
      });
    });
  });
}

void testGetPriorityGroups(
  MockDatabase db,
  DatabasePriorityGroupRepository repository,
) {
  group("getPriorityGroups function:", () {
    final int validPriorityGroupId = 1;
    final expectedPriorityGroups = [
      PriorityGroup(
        id: validPriorityGroupId,
        code: "Pessoas com mais de 60 anos",
        name: "Idosos",
        description: "Grupo de pessoas com mais de 60 anos",
      ),
      PriorityGroup(
        id: validPriorityGroupId + 1,
        code: "Pessoas com idade entre 12 e 18 anos",
        name: "Adolescentes",
        description: "Grupo de adolescentes",
      ),
      PriorityGroup(
        id: validPriorityGroupId + 3,
        code: "Pessoas com menos de 12 anos",
        name: "Crianças",
        description: "Grupo de crianças",
      ),
    ];

    group('try to get all priorityGroups', () {
      setUp(() {
        when(db.query(
          DatabasePriorityGroupRepository.TABLE,
        )).thenAnswer((_) => Future.value([
              {
                'id': validPriorityGroupId,
                'code': "Pessoas com mais de 60 anos",
                'name': "Idosos",
                'description': "Grupo de pessoas com mais de 60 anos",
              },
              {
                'id': validPriorityGroupId + 1,
                'code': "Pessoas com idade entre 12 e 18 anos",
                'name': "Adolescentes",
                'description': "Grupo de adolescentes",
              },
              {
                'id': validPriorityGroupId + 3,
                'code': "Pessoas com menos de 12 anos",
                'name': "Crianças",
                'description': "Grupo de crianças",
              },
            ]));
      });

      test("should return all priorityGroups", () async {
        final actualPriorityGroups = await repository.getPriorityGroups();

        expect(actualPriorityGroups, isA<List<PriorityGroup>>());
        for (int i = 0; i < actualPriorityGroups.length; i++) {
          expect(actualPriorityGroups[i], expectedPriorityGroups[i]);
        }
      });
    });

    group('try to get all priorityGroups when there is none', () {
      setUp(() {
        when(db.query(
          DatabasePriorityGroupRepository.TABLE,
        )).thenAnswer((_) => Future.value([]));
      });

      test("should return an empty list", () async {
        final actualPriorityGroups = await repository.getPriorityGroups();

        expect(actualPriorityGroups, isA<List<PriorityGroup>>());
        expect(actualPriorityGroups, isEmpty);
      });
    });
  });
}

void testUpdatePriorityGroup(
  MockDatabase db,
  DatabasePriorityGroupRepository repository,
) {
  group("updatePriorityGroup function:", () {
    final int validPriorityGroupId = 1;
    final int invalidPriorityGroupId = 2;
    final validPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      code: "Pessoas com mais de 60 anos",
      name: "Idoso",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    group('try to update a valid priorityGroup', () {
      setUp(() {
        when(db.update(
          DatabasePriorityGroupRepository.TABLE,
          validPriorityGroup.copyWith(name: "Idosos").toMap(),
          where: anyNamed("where"),
          whereArgs: [validPriorityGroupId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a priorityGroup entry and returns 1", () async {
        final updatedCount = await repository.updatePriorityGroup(
          validPriorityGroup.copyWith(name: "Idosos"),
        );

        expect(updatedCount, 1);
      });
    });

    group('try to update invalid priorityGroup', () {
      setUp(() {
        when(db.update(
          DatabasePriorityGroupRepository.TABLE,
          validPriorityGroup
              .copyWith(id: invalidPriorityGroupId, name: "Idosos")
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [invalidPriorityGroupId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updatePriorityGroup(
          validPriorityGroup.copyWith(
              id: invalidPriorityGroupId, name: "Idosos"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}
