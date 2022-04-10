import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_priority_group_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabasePriorityCategoryRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();
  final repository = DatabasePriorityCategoryRepository(dbManager);

  setUp(() {
    when(dbManager.db).thenReturn(db);
  });

  testCreatePriorityCategory(db, repository);
  testDeletePriorityCategory(db, repository);
  testGetPriorityCategory(db, repository);
  testGetPriorityCategories(db, repository);
  testUpdatePriorityCategory(db, repository);
}

void testCreatePriorityCategory(
  MockDatabase db,
  DatabasePriorityCategoryRepository repository,
) {
  group("createPriorityCategory function:", () {
    final int validPriorityCategoryId = 1;
    final int validPriorityGroupId = 1;

    final validPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      groupCode: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    final expectedPriorityCategory = PriorityCategory(
      id: validPriorityCategoryId,
      priorityGroup: validPriorityGroup,
      categoryCode: "Pessoas idosas",
      name: "Idosos",
      description: "Categoria para pessoas idosas",
    );

    group('try to create a valid priorityCategory', () {
      setUp(() {
        when(db.insert(DatabasePriorityCategoryRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new priorityCategory entry and return its id",
          () async {
        final createdId =
            await repository.createPriorityCategory(expectedPriorityCategory);

        expect(createdId, 1);
      });
    });
  });
}

void testDeletePriorityCategory(
  MockDatabase db,
  DatabasePriorityCategoryRepository repository,
) {
  group("deletePriorityCategory function:", () {
    final int validPriorityCategoryId = 1;
    final int invalidPriorityCategoryId = 2;

    group('try to delete valid priorityCategory', () {
      setUp(() {
        when(db.delete(
          DatabasePriorityCategoryRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPriorityCategoryId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a priorityCategory entry and returns 1", () async {
        final deletedCount =
            await repository.deletePriorityCategory(validPriorityCategoryId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid priorityCategory', () {
      setUp(() {
        when(db.delete(
          DatabasePriorityCategoryRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [invalidPriorityCategoryId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final deletedCount =
            await repository.deletePriorityCategory(invalidPriorityCategoryId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetPriorityCategory(
  MockDatabase db,
  DatabasePriorityCategoryRepository repository,
) {
  group("getPriorityCategory function:", () {
    final int validPriorityCategoryId = 1;
    final int validPriorityGroupId = 1;
    final int invalidPriorityCategoryId = 2;

    final validPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      groupCode: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    final expectedPriorityCategory = PriorityCategory(
      id: validPriorityCategoryId,
      priorityGroup: validPriorityGroup,
      categoryCode: "Pessoas idosas",
      name: "Idosos",
      description: "Categoria para pessoas idosas",
    );

    group('try to get valid priorityCategory', () {
      setUp(() {
        when(db.query(
          DatabasePriorityCategoryRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPriorityCategoryId],
        )).thenAnswer(
          (_) => Future.value([
            {
              'id': expectedPriorityCategory.id,
              'priorityGroup': expectedPriorityCategory.priorityGroup.id,
              'categoryCode': expectedPriorityCategory.categoryCode,
              'name': expectedPriorityCategory.name,
              'description': expectedPriorityCategory.description,
            }
          ]),
        );

        when(db.query(
          DatabasePriorityGroupRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validPriorityGroupId],
        )).thenAnswer(
          (_) => Future.value([
            {
              'id': validPriorityGroup.id,
              'groupCode': validPriorityGroup.groupCode,
              'name': validPriorityGroup.name,
              'description': validPriorityGroup.description,
            }
          ]),
        );
      });

      test("should get a priorityCategory entry by its id", () async {
        final actualPriorityCategory =
            await repository.getPriorityCategoryById(validPriorityCategoryId);

        expect(actualPriorityCategory, isA<PriorityCategory>());
        expect(actualPriorityCategory, expectedPriorityCategory);
      });
    });

    group('try to get an invalid priorityCategory', () {
      setUp(() {
        when(db.query(
          DatabasePriorityCategoryRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [invalidPriorityCategoryId],
        )).thenAnswer((_) => Future.value([]));
      });

      test("should throw exception if id doesn't exist", () async {
        expect(
          () async => await repository.getPriorityCategoryById(2),
          throwsStateError,
        );
      });
    });
  });
}

void testGetPriorityCategories(
  MockDatabase db,
  DatabasePriorityCategoryRepository repository,
) {
  group("getPriorityCategories function:", () {
    final int validPriorityCategoryId = 1;
    final int validPriorityGroupId = 1;

    final validPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      groupCode: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    final expectedPriorityCategories = [
      PriorityCategory(
        id: validPriorityCategoryId,
        priorityGroup: validPriorityGroup,
        categoryCode: "Pessoas idosas",
        name: "Idosos",
        description: "Categoria para pessoas idosas",
      ),
      PriorityCategory(
        id: validPriorityCategoryId + 1,
        priorityGroup: validPriorityGroup,
        categoryCode: "Pessoas menores de idade",
        name: "Adolescentes",
        description: "Categoria de adolescentes",
      ),
      PriorityCategory(
        id: validPriorityCategoryId + 2,
        priorityGroup: validPriorityGroup,
        categoryCode: "Pessoas com menos de 12 anos",
        name: "Crianças",
        description: "Categoria de crianças",
      ),
    ];

    group('try to get all priorityCategories', () {
      setUp(() {
        when(db.query(
          DatabasePriorityCategoryRepository.TABLE,
        )).thenAnswer((_) => Future.value([
              {
                'id': expectedPriorityCategories[0].id,
                'priorityGroup': expectedPriorityCategories[0].priorityGroup,
                'categoryCode': expectedPriorityCategories[0].categoryCode,
                'name': expectedPriorityCategories[0].name,
                'description': expectedPriorityCategories[0].description,
              },
              {
                'id': expectedPriorityCategories[1].id,
                'priorityGroup': expectedPriorityCategories[1].priorityGroup,
                'categoryCode': expectedPriorityCategories[1].categoryCode,
                'name': expectedPriorityCategories[1].name,
                'description': expectedPriorityCategories[1].description,
              },
              {
                'id': expectedPriorityCategories[2].id,
                'priorityGroup': expectedPriorityCategories[2].priorityGroup,
                'categoryCode': expectedPriorityCategories[2].categoryCode,
                'name': expectedPriorityCategories[2].name,
                'description': expectedPriorityCategories[2].description,
              },
            ]));
      });

      test("should return all priorityCategories", () async {
        final actualPriorityCategories =
            await repository.getPriorityCategories();

        expect(actualPriorityCategories, isA<List<PriorityCategory>>());
        for (int i = 0; i < actualPriorityCategories.length; i++) {
          expect(actualPriorityCategories[i], expectedPriorityCategories[i]);
        }
      });
    });

    group('try to get all priorityCategories when there is none', () {
      setUp(() {
        when(db.query(
          DatabasePriorityCategoryRepository.TABLE,
        )).thenAnswer((_) => Future.value([]));
      });

      test("should return an empty list", () async {
        final actualPriorityCategories =
            await repository.getPriorityCategories();

        expect(actualPriorityCategories, isA<List<PriorityCategory>>());
        expect(actualPriorityCategories, isEmpty);
      });
    });
  });
}

void testUpdatePriorityCategory(
  MockDatabase db,
  DatabasePriorityCategoryRepository repository,
) {
  group("updatePriorityCategory function:", () {
    final int validPriorityCategoryId = 1;
    final int validPriorityGroupId = 1;
    final int invalidPriorityCategoryId = 2;

    final validPriorityGroup = PriorityGroup(
      id: validPriorityGroupId,
      groupCode: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    final expectedPriorityCategory = PriorityCategory(
      id: validPriorityCategoryId,
      priorityGroup: validPriorityGroup,
      categoryCode: "Pessoas idosas",
      name: "Idoso",
      description: "Categoria para pessoas idosas",
    );

    group('try to update a valid priorityCategory', () {
      setUp(() {
        when(db.update(
          DatabasePriorityCategoryRepository.TABLE,
          expectedPriorityCategory.copyWith(name: "Idosos").toMap(),
          where: anyNamed("where"),
          whereArgs: [validPriorityCategoryId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a priorityCategory entry and returns 1", () async {
        final updatedCount = await repository.updatePriorityCategory(
          expectedPriorityCategory.copyWith(name: "Idosos"),
        );

        expect(updatedCount, 1);
      });
    });

    group('try to update invalid priorityCategory', () {
      setUp(() {
        when(db.update(
          DatabasePriorityCategoryRepository.TABLE,
          expectedPriorityCategory
              .copyWith(id: invalidPriorityCategoryId, name: "Idosos")
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [invalidPriorityCategoryId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updatePriorityCategory(
          expectedPriorityCategory.copyWith(
              id: invalidPriorityCategoryId, name: "Idosos"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}
