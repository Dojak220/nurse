import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_campaign_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabaseCampaignRepository])
void main() {
  final db = MockDatabase();
  final dbManager = MockDatabaseManager();

  final repository = DatabaseCampaignRepository(dbManager);

  setUp(() {
    when(dbManager.db).thenReturn(db);
  });

  testCreateCampaign(db, repository);
  testDeleteCampaign(db, repository);
  testGetCampaign(db, repository);
  testGetCampaigns(db, repository);
  testUpdateCampaign(db, repository);
}

void testCreateCampaign(
  MockDatabase db,
  DatabaseCampaignRepository repository,
) {
  group("createCampaign function:", () {
    final int validCampaignId = 1;
    final validCampaign = Campaign(
      id: validCampaignId,
      title: "Campaign Title",
      startDate: DateTime(2022),
    );

    group('try to create a valid campaign', () {
      setUp(() {
        when(db.insert(DatabaseCampaignRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new campaign entry and return its id", () async {
        final createdId = await repository.createCampaign(validCampaign);

        expect(createdId, 1);
      });
    });
  });
}

void testDeleteCampaign(
  MockDatabase db,
  DatabaseCampaignRepository repository,
) {
  group("deleteCampaign function:", () {
    final int validCampaignId = 1;
    final int invalidCampaignId = 2;

    group('try to delete valid campaign', () {
      setUp(() {
        when(db.delete(
          DatabaseCampaignRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validCampaignId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a campaign entry and returns 1", () async {
        final deletedCount = await repository.deleteCampaign(validCampaignId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid campaign', () {
      setUp(() {
        when(db.delete(
          DatabaseCampaignRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [invalidCampaignId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final deletedCount = await repository.deleteCampaign(invalidCampaignId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetCampaign(
  MockDatabase db,
  DatabaseCampaignRepository repository,
) {
  group("getCampaign function:", () {
    final int validCampaignId = 1;
    final expectedCampaign = Campaign(
      id: validCampaignId,
      title: "Campaign Title",
      startDate: DateTime(2022),
    );

    group('try to get valid campaign', () {
      setUp(() {
        when(db.query(
          DatabaseCampaignRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [validCampaignId],
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedCampaign.id,
                "title": expectedCampaign.title,
                "description": expectedCampaign.description,
                "startDate": expectedCampaign.startDate.millisecondsSinceEpoch,
                "endDate": expectedCampaign.endDate.millisecondsSinceEpoch,
              }
            ]));
      });

      test("should get a campaign entry by its id", () async {
        final actualCampaign =
            await repository.getCampaignById(validCampaignId);

        expect(actualCampaign, isA<Campaign>());
        expect(actualCampaign, expectedCampaign);
      });
    });

    group('try to get an invalid campaign', () {
      setUp(() {
        when(db.query(
          DatabaseCampaignRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [2],
        )).thenAnswer((_) => Future.value([]));
      });

      test("should throw exception if id doesn't exist", () async {
        expect(
          () async => await repository.getCampaignById(2),
          throwsStateError,
        );
      });
    });
  });
}

void testGetCampaigns(
  MockDatabase db,
  DatabaseCampaignRepository repository,
) {
  group("getCampaigns function:", () {
    final int validCampaignId = 1;
    final validCampaign = Campaign(
      id: validCampaignId,
      title: "Campaign Title",
      startDate: DateTime(2022),
    );

    final expectedCampaigns = [
      validCampaign,
      validCampaign.copyWith(
        id: validCampaignId + 1,
        title: "Campaign Title 2",
        startDate: DateTime(2022).add(Duration(days: 1)),
      ),
      validCampaign.copyWith(
        id: validCampaignId + 1,
        title: "Campaign Title 2",
        startDate: DateTime(2022).add(Duration(days: 1)),
      ),
    ];

    group('try to get all campaigns', () {
      setUp(() {
        when(db.query(
          DatabaseCampaignRepository.TABLE,
        )).thenAnswer(
          (_) => Future.value([
            {
              "id": expectedCampaigns[0].id,
              "title": expectedCampaigns[0].title,
              "description": expectedCampaigns[0].description,
              "startDate":
                  expectedCampaigns[0].startDate.millisecondsSinceEpoch,
              "endDate": expectedCampaigns[0].endDate.millisecondsSinceEpoch,
            },
            {
              "id": expectedCampaigns[1].id,
              "title": expectedCampaigns[1].title,
              "description": expectedCampaigns[1].description,
              "startDate":
                  expectedCampaigns[1].startDate.millisecondsSinceEpoch,
              "endDate": expectedCampaigns[1].endDate.millisecondsSinceEpoch,
            },
            {
              "id": expectedCampaigns[2].id,
              "title": expectedCampaigns[2].title,
              "description": expectedCampaigns[2].description,
              "startDate":
                  expectedCampaigns[2].startDate.millisecondsSinceEpoch,
              "endDate": expectedCampaigns[2].endDate.millisecondsSinceEpoch,
            },
          ]),
        );
      });

      test("should return all campaigns", () async {
        final actualCampaigns = await repository.getCampaigns();

        expect(actualCampaigns, isA<List<Campaign>>());
        for (int i = 0; i < actualCampaigns.length; i++) {
          expect(actualCampaigns[i], expectedCampaigns[i]);
        }
      });
    });

    group('try to get all campaigns when there is none', () {
      setUp(() {
        when(db.query(
          DatabaseCampaignRepository.TABLE,
        )).thenAnswer((_) => Future.value([]));
      });

      test("should return an empty list", () async {
        final actualCampaigns = await repository.getCampaigns();

        expect(actualCampaigns, isA<List<Campaign>>());
        expect(actualCampaigns, isEmpty);
      });
    });
  });
}

void testUpdateCampaign(
  MockDatabase db,
  DatabaseCampaignRepository repository,
) {
  group("updateCampaign function:", () {
    final int validCampaignId = 1;
    final int invalidCampaignId = 2;
    final validCampaign = Campaign(
      id: validCampaignId,
      title: "Campaign Title",
      startDate: DateTime(2022),
    );

    group('try to update a valid campaign', () {
      setUp(() {
        when(db.update(
          DatabaseCampaignRepository.TABLE,
          validCampaign.copyWith(title: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [validCampaignId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a campaign entry and returns 1", () async {
        final updatedCount = await repository.updateCampaign(
          validCampaign.copyWith(title: "Updated"),
        );

        expect(updatedCount, 1);
      });
    });

    group('try to update invalid campaign', () {
      setUp(() {
        when(db.update(
          DatabaseCampaignRepository.TABLE,
          validCampaign
              .copyWith(id: invalidCampaignId, title: "Updated")
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [invalidCampaignId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updateCampaign(
          validCampaign.copyWith(id: invalidCampaignId, title: "Updated"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}
