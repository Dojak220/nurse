import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_category_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_priority_group_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabasePriorityGroupRepository])
void main() {
  final dbMock = MockDatabase();
  final dbManagerMock = MockDatabaseManager();
  final groupRepoMock = MockDatabasePriorityGroupRepository();

  final repository = DatabasePriorityCategoryRepository(
    dbManager: dbManagerMock,
    groupRepo: groupRepoMock,
  );

  setUp(() {
    when(dbManagerMock.db).thenReturn(dbMock);
    when(groupRepoMock.getPriorityGroupById(1))
        .thenAnswer((_) async => _validPriorityGroup);
    when(groupRepoMock.getPriorityGroupByCode("Pessoas com mais de 60 anos"))
        .thenAnswer((_) async => _validPriorityGroup);
    when(groupRepoMock.getPriorityGroups())
        .thenAnswer((_) async => _validPriorityGroups);
  });

  testCreatePriorityCategory(dbMock, repository);
  testDeletePriorityCategory(dbMock, repository);
  testGetPriorityCategory(dbMock, repository);
  testGetPriorityCategories(dbMock, repository);
  testUpdatePriorityCategory(dbMock, repository);
}

void testCreatePriorityCategory(
  MockDatabase db,
  PriorityCategoryRepository repository,
) {
  group("createPriorityCategory function:", () {
    group('try to create a valid priorityCategory', () {
      setUp(() {
        when(db.insert(DatabasePriorityCategoryRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new priorityCategory entry and return its id",
          () async {
        final createdId =
            await repository.createPriorityCategory(_validPriorityCategory);

        expect(createdId, 1);
      });
    });
  });
}

void testDeletePriorityCategory(
  MockDatabase db,
  PriorityCategoryRepository repository,
) {
  group("deletePriorityCategory function:", () {
    group('try to delete valid priorityCategory', () {
      setUp(() {
        when(db.delete(
          DatabasePriorityCategoryRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validPriorityCategoryId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a priorityCategory entry and returns 1", () async {
        final deletedCount =
            await repository.deletePriorityCategory(_validPriorityCategoryId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid priorityCategory', () {
      setUp(() {
        when(db.delete(
          DatabasePriorityCategoryRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_invalidPriorityCategoryId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final deletedCount =
            await repository.deletePriorityCategory(_invalidPriorityCategoryId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetPriorityCategory(
  MockDatabase db,
  PriorityCategoryRepository repository,
) {
  group("getPriorityCategory function:", () {
    final expectedPriorityCategory = _validPriorityCategory;

    group('try to get valid priorityCategory', () {
      setUp(() {
        when(db.query(
          DatabasePriorityCategoryRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validPriorityCategoryId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": expectedPriorityCategory.id,
              "priority_group": expectedPriorityCategory.priorityGroup.id,
              "code": expectedPriorityCategory.code,
              "name": expectedPriorityCategory.name,
              "description": expectedPriorityCategory.description,
            }
          ]),
        );
      });

      test("should get a priorityCategory entry by its id", () async {
        final actualPriorityCategory =
            await repository.getPriorityCategoryById(_validPriorityCategoryId);

        expect(actualPriorityCategory, isA<PriorityCategory>());
        expect(actualPriorityCategory, expectedPriorityCategory);
      });
    });

    group('try to get an invalid priorityCategory', () {
      setUp(() {
        when(db.query(
          DatabasePriorityCategoryRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_invalidPriorityCategoryId],
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
  PriorityCategoryRepository repository,
) {
  group("getPriorityCategories function:", () {
    final expecPriorityCategories = _validPriorityCategories;

    group('try to get all priorityCategories', () {
      setUp(
        () {
          when(db.query(
            DatabasePriorityCategoryRepository.TABLE,
          )).thenAnswer(
            (_) => Future.value(
              [
                {
                  "id": expecPriorityCategories[0].id,
                  "priority_group": expecPriorityCategories[0].priorityGroup.id,
                  "code": expecPriorityCategories[0].code,
                  "name": expecPriorityCategories[0].name,
                  "description": expecPriorityCategories[0].description,
                },
                {
                  "id": expecPriorityCategories[1].id,
                  "priority_group": expecPriorityCategories[1].priorityGroup.id,
                  "code": expecPriorityCategories[1].code,
                  "name": expecPriorityCategories[1].name,
                  "description": expecPriorityCategories[1].description,
                },
                {
                  "id": expecPriorityCategories[2].id,
                  "priority_group": expecPriorityCategories[2].priorityGroup.id,
                  "code": expecPriorityCategories[2].code,
                  "name": expecPriorityCategories[2].name,
                  "description": expecPriorityCategories[2].description,
                },
              ],
            ),
          );
        },
      );

      test("should return all priorityCategories", () async {
        final actualPriorityCategories =
            await repository.getPriorityCategories();

        expect(actualPriorityCategories, isA<List<PriorityCategory>>());
        for (int i = 0; i < actualPriorityCategories.length; i++) {
          expect(actualPriorityCategories[i], expecPriorityCategories[i]);
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
  PriorityCategoryRepository repository,
) {
  group("updatePriorityCategory function:", () {
    final expectedPriorityCategory = _validPriorityCategory;

    group('try to update a valid priorityCategory', () {
      setUp(() {
        when(db.update(
          DatabasePriorityCategoryRepository.TABLE,
          expectedPriorityCategory.copyWith(name: "Idosos").toMap(),
          where: anyNamed("where"),
          whereArgs: [_validPriorityCategoryId],
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
              .copyWith(id: _invalidPriorityCategoryId, name: "Idosos")
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [_invalidPriorityCategoryId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updatePriorityCategory(
          expectedPriorityCategory.copyWith(
              id: _invalidPriorityCategoryId, name: "Idosos"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}

const int _validPriorityCategoryId = 1;
const int _validPriorityGroupId = 1;

const int _invalidPriorityCategoryId = 2;

final _validPriorityGroup = PriorityGroup(
  id: _validPriorityGroupId,
  code: "Pessoas com mais de 60 anos",
  name: "Idosos",
  description: "Grupo de pessoas com mais de 60 anos",
);

final _validPriorityCategory = PriorityCategory(
  id: _validPriorityCategoryId,
  priorityGroup: _validPriorityGroup,
  code: "Pessoas idosas",
  name: "Idosos",
  description: "Categoria para pessoas idosas",
);

final _validPriorityGroups = [
  _validPriorityGroup,
  _validPriorityGroup.copyWith(
    id: _validPriorityGroupId + 1,
    code: "Pessoas com idade entre 12 e 18 anos",
    name: "Adolescentes",
    description: "Grupo de adolescentes",
  ),
  _validPriorityGroup.copyWith(
    id: _validPriorityGroupId + 2,
    code: "Pessoas com menos de 12 anos",
    name: "Crianças",
    description: "Grupo de crianças",
  ),
];

final _validPriorityCategories = [
  _validPriorityCategory,
  _validPriorityCategory.copyWith(
    id: _validPriorityCategoryId + 1,
    code: "Pessoas menores de idade",
    name: "Adolescentes",
    description: "Categoria de adolescentes",
  ),
  _validPriorityCategory.copyWith(
    id: _validPriorityCategoryId + 2,
    code: "Pessoas com menos de 12 anos",
    name: "Crianças",
    description: "Categoria de crianças",
  ),
];
