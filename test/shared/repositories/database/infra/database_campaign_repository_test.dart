import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_campaign_repository_test.mocks.dart';

@GenerateMocks([DatabaseManager, Database, DatabaseCampaignRepository])
void main() {
  final dbMock = MockDatabase();
  final dbManagerMock = MockDatabaseManager();

  final repository = DatabaseCampaignRepository(dbManagerMock);

  setUp(() {
    when(dbManagerMock.db).thenReturn(dbMock);
  });

  testCreateCampaign(dbMock, repository);
  testDeleteCampaign(dbMock, repository);
  testGetCampaign(dbMock, repository);
  testGetCampaigns(dbMock, repository);
  testUpdateCampaign(dbMock, repository);
}

void testCreateCampaign(MockDatabase db, CampaignRepository repository) {
  group("createCampaign function:", () {
    group('try to create a valid campaign', () {
      setUp(() {
        when(db.insert(DatabaseCampaignRepository.TABLE, any,
                conflictAlgorithm: anyNamed("conflictAlgorithm")))
            .thenAnswer((_) => Future.value(1));
      });

      test("should create a new campaign entry and return its id", () async {
        final createdId = await repository.createCampaign(_validCampaign);

        expect(createdId, 1);
      });
    });
  });
}

void testDeleteCampaign(MockDatabase db, CampaignRepository repository) {
  group("deleteCampaign function:", () {
    group('try to delete valid campaign', () {
      setUp(() {
        when(db.delete(
          DatabaseCampaignRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validCampaignId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should delete a campaign entry and returns 1", () async {
        final deletedCount = await repository.deleteCampaign(_validCampaignId);

        expect(deletedCount, 1);
      });
    });

    group('try to delete invalid campaign', () {
      setUp(() {
        when(db.delete(
          DatabaseCampaignRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_invalidCampaignId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final deletedCount =
            await repository.deleteCampaign(_invalidCampaignId);

        expect(deletedCount, 0);
      });
    });
  });
}

void testGetCampaign(MockDatabase db, CampaignRepository repository) {
  group("getCampaign function:", () {
    final expectedCampaign = _validCampaign;
    group('try to get valid campaign', () {
      setUp(() {
        when(db.query(
          DatabaseCampaignRepository.TABLE,
          where: anyNamed("where"),
          whereArgs: [_validCampaignId],
        )).thenAnswer((_) => Future.value([
              {
                "id": expectedCampaign.id,
                "title": expectedCampaign.title,
                "description": expectedCampaign.description,
                "start_date": expectedCampaign.startDate.toString(),
                "end_date": expectedCampaign.endDate.toString(),
              }
            ]));
      });

      test("should get a campaign entry by its id", () async {
        final actualCampaign =
            await repository.getCampaignById(_validCampaignId);

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

void testGetCampaigns(MockDatabase db, CampaignRepository repository) {
  group("getCampaigns function:", () {
    final expectedCampaigns = _validCampaigns;

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
              "start_date": expectedCampaigns[0].startDate.toString(),
              "end_date": expectedCampaigns[0].endDate.toString(),
            },
            {
              "id": expectedCampaigns[1].id,
              "title": expectedCampaigns[1].title,
              "description": expectedCampaigns[1].description,
              "start_date": expectedCampaigns[1].startDate.toString(),
              "end_date": expectedCampaigns[1].endDate.toString(),
            },
            {
              "id": expectedCampaigns[2].id,
              "title": expectedCampaigns[2].title,
              "description": expectedCampaigns[2].description,
              "start_date": expectedCampaigns[2].startDate.toString(),
              "end_date": expectedCampaigns[2].endDate.toString(),
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

void testUpdateCampaign(MockDatabase db, CampaignRepository repository) {
  group("updateCampaign function:", () {
    group('try to update a valid campaign', () {
      setUp(() {
        when(db.update(
          DatabaseCampaignRepository.TABLE,
          _validCampaign.copyWith(title: "Updated").toMap(),
          where: anyNamed("where"),
          whereArgs: [_validCampaignId],
        )).thenAnswer((_) => Future.value(1));
      });

      test("should update a campaign entry and returns 1", () async {
        final updatedCount = await repository.updateCampaign(
          _validCampaign.copyWith(title: "Updated"),
        );

        expect(updatedCount, 1);
      });
    });

    group('try to update invalid campaign', () {
      setUp(() {
        when(db.update(
          DatabaseCampaignRepository.TABLE,
          _validCampaign
              .copyWith(id: _invalidCampaignId, title: "Updated")
              .toMap(),
          where: anyNamed("where"),
          whereArgs: [_invalidCampaignId],
        )).thenAnswer((_) => Future.value(0));
      });

      test("should return 0 if id doesn't exist", () async {
        final updatedCount = await repository.updateCampaign(
          _validCampaign.copyWith(id: _invalidCampaignId, title: "Updated"),
        );

        expect(updatedCount, 0);
      });
    });
  });
}

const int _validCampaignId = 1;
const int _invalidCampaignId = 2;

final _validCampaign = Campaign(
  id: _validCampaignId,
  title: "Campaign Title",
  startDate: DateTime(2022),
  endDate: DateTime(2023),
  description: "Campaign Description",
);

final _validCampaigns = [
  _validCampaign,
  _validCampaign.copyWith(
    id: _validCampaignId + 1,
    title: "Campaign Title 2",
    startDate: DateTime(2022).add(const Duration(days: 1)),
  ),
  _validCampaign.copyWith(
    id: _validCampaignId + 1,
    title: "Campaign Title 3",
    startDate: DateTime(2022).add(const Duration(days: 100)),
  ),
];
