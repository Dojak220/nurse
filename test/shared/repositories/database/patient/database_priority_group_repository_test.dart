import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_group_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_priority_group_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabasePriorityGroupRepository])
void main() {
  final dbMock = MockDatabase();
  final dbManagerMock = MockDatabaseManager();

  final repository = DatabasePriorityGroupRepository(dbManagerMock);

  setUp(() {
    when(dbManagerMock.db).thenReturn(dbMock);
  });

  testCreatePriorityGroup(dbMock, repository);
  testDeletePriorityGroup(dbMock, repository);
  testGetPriorityGroup(dbMock, repository);
  testGetPriorityGroups(dbMock, repository);
  testUpdatePriorityGroup(dbMock, repository);
}

void testCreatePriorityGroup(
  MockDatabase db,
  PriorityGroupRepository repository,
) {
  group("createPriorityGroup function:", () {
    group('try to create a valid priorityGroup', () {
      setUp(() {
        when(db.insert(DatabasePriorityGroupRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new priorityGroup entry and return its id",
          () async {
        final createdId =
            await repository.createPriorityGroup(_validPriorityGroup);

        expect(createdId, 1);
      });
    });
  });
}

void testDeletePriorityGroup(
  MockDatabase db,
  PriorityGroupRepository repository,
) {
  group("deletePriorityGroup function:", () {
    group('try to delete valid priorityGroup', () {
      setUp(() {
        when(db.delete(
          DatabasePriorityGroupRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validPriorityGroupId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a priorityGroup entry and returns 1", () async {
        final deletedCount =
            await repository.deletePriorityGroup(_validPriorityGroupId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid priorityGroup', () {
      setUp(() {
        when(db.delete(
          DatabasePriorityGroupRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_invalidPriorityGroupId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final deletedCount =
            await repository.deletePriorityGroup(_invalidPriorityGroupId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetPriorityGroup(
  MockDatabase db,
  PriorityGroupRepository repository,
) {
  group("getPriorityGroup function:", () {
    final expectedPriorityGroup = _validPriorityGroup;

    group('try to get valid priorityGroup', () {
      setUp(() {
        when(db.query(
          DatabasePriorityGroupRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validPriorityGroupId],
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": expectedPriorityGroup.id,
              "code": expectedPriorityGroup.code,
              "name": expectedPriorityGroup.name,
              "description": expectedPriorityGroup.description,
            }
          ]),
        );
      });

      test("should get a priorityGroup entry by its id", () async {
        final actualPriorityGroup =
            await repository.getPriorityGroupById(_validPriorityGroupId);

        expect(actualPriorityGroup, isA<PriorityGroup>());
        expect(actualPriorityGroup, expectedPriorityGroup);
      });
    });

    group('try to get an invalid priorityGroup', () {
      setUp(() {
        when(db.query(
          DatabasePriorityGroupRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_invalidPriorityGroupId],
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
  PriorityGroupRepository repository,
) {
  group("getPriorityGroups function:", () {
    final expectedPriorityGroups = _validPriorityGroups;

    group('try to get all priorityGroups', () {
      setUp(() {
        when(db.query(
          DatabasePriorityGroupRepository.TABLE,
        )).thenAnswer((_) => Future.value([
              {
                "id": _validPriorityGroupId,
                "code": "Pessoas com mais de 60 anos",
                "name": "Idosos",
                "description": "Grupo de pessoas com mais de 60 anos",
              },
              {
                "id": _validPriorityGroupId + 1,
                "code": "Pessoas com idade entre 12 e 18 anos",
                "name": "Adolescentes",
                "description": "Grupo de adolescentes",
              },
              {
                "id": _validPriorityGroupId + 3,
                "code": "Pessoas com menos de 12 anos",
                "name": "Crianças",
                "description": "Grupo de crianças",
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
  PriorityGroupRepository repository,
) {
  group("updatePriorityGroup function:", () {
    group('try to update a valid priorityGroup', () {
      setUp(() {
        when(db.update(
          DatabasePriorityGroupRepository.TABLE,
          _validPriorityGroup.copyWith(name: "Idosos").toMap(),
          where: anyNamed("where"),
          whereArgs: [_validPriorityGroupId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a priorityGroup entry and returns 1", () async {
        final updatedCount = await repository.updatePriorityGroup(
          _validPriorityGroup.copyWith(name: "Idosos"),
        );

        expect(updatedCount, 1);
      });
    });

    group('try to update invalid priorityGroup', () {
      setUp(() {
        when(db.update(
          DatabasePriorityGroupRepository.TABLE,
          _validPriorityGroup
              .copyWith(id: _invalidPriorityGroupId, name: "Idosos")
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [_invalidPriorityGroupId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updatePriorityGroup(
          _validPriorityGroup.copyWith(
              id: _invalidPriorityGroupId, name: "Idosos"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}

const int _validPriorityGroupId = 1;
const int _invalidPriorityGroupId = 2;

final _validPriorityGroup = PriorityGroup(
  id: _validPriorityGroupId,
  code: "Pessoas com mais de 60 anos",
  name: "Idosos",
  description: "Grupo de pessoas com mais de 60 anos",
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
    id: _validPriorityGroupId + 3,
    code: "Pessoas com menos de 12 anos",
    name: "Crianças",
    description: "Grupo de crianças",
  ),
];
