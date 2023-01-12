import "package:flutter_test/flutter_test.dart";
import "package:nurse/shared/models/infra/campaign_model.dart";

void main() {
  late Campaign validCampaign;
  final DateTime startDate = DateTime(2022);

  setUp(() {
    validCampaign = Campaign(
      id: 1,
      title: "Campaign Title",
      description: "Campaign Description",
      startDate: startDate,
    );
  });

  group("campaign model valid instance creation", () {
    test("should create a valid instance", () {
      expect(validCampaign, isA<Campaign>());
      expect(validCampaign.id, 1);
      expect(validCampaign.title, "Campaign Title");
      expect(validCampaign.description, "Campaign Description");
      expect(validCampaign.startDate, DateTime(2022));
      expect(validCampaign.endDate, DateTime(2023));
    });

    test(
        "should return a campaign with title and description equals when description is empty",
        () {
      final Campaign actualCampaign = validCampaign.copyWith(description: "");

      expect(actualCampaign.description, actualCampaign.title);
      expect(actualCampaign.description, validCampaign.title);
    });

    test("should create a valid instance of a future campaign", () {
      final DateTime today = DateTime.now();
      final DateTime tomorrow = DateTime(
        today.year,
        today.month,
        today.day,
      ).add(const Duration(days: 1));

      final Campaign actualCampaign = validCampaign.copyWith(
        startDate: tomorrow,
      );

      expect(actualCampaign.startDate, tomorrow);
    });

    test("should create a valid instance of a past campaign", () {
      final today = DateTime.now();
      final yesterday = DateTime(
        today.year,
        today.month,
        today.day,
      ).add(const Duration(days: -1));

      final Campaign actualCampaign = validCampaign.copyWith(
        startDate: DateTime(2022),
        endDate: yesterday,
      );

      expect(actualCampaign.endDate, yesterday);
    });

    test(
        "should return a campaign with description empty if description has only spaces",
        () {
      final Campaign actualCampaign = validCampaign.copyWith(description: " ");

      expect(actualCampaign.description, actualCampaign.title);
      expect(actualCampaign.description, validCampaign.title);
    });
  });

  group("campaign model invalid instance creation", () {
    test("should throw exception if id is 0", () {
      expect(
        () => validCampaign.copyWith(id: 0),
        throwsException,
        reason: "it's not possible to create a campaign with id 0",
      );
    });

    test("should throw exception if id is negative", () {
      expect(
        () => validCampaign.copyWith(id: -1),
        throwsException,
        reason: "it's not possible to create a campaign with id -1",
      );
    });

    test("should throw exception if title is empty", () {
      expect(
        () => validCampaign.copyWith(title: ""),
        throwsException,
        reason: "it's not possible to create a campaign with an empty title",
      );
    });

    test("should throw exception if title has only spaces", () {
      expect(
        () => validCampaign.copyWith(title: "  "),
        throwsException,
        reason: "it's not possible to create a campaign with an invalid title",
      );
    });

    test("should throw exception if title has weird characters", () {
      expect(
        () => validCampaign.copyWith(
          title: "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?",
        ),
        throwsException,
        reason: "it's not possible to create a campaign with an invalid title",
      );
    });

    test("should throw exception if description has weird characters", () {
      expect(
        () => validCampaign.copyWith(
          description:
              "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?",
        ),
        throwsException,
        reason:
            "it's not possible to create a campaign with an invalid description",
      );
    });

    test("should throw exception if startDate is invalid", () {
      expect(
        () => validCampaign.copyWith(startDate: DateTime(1899)),
        throwsException,
        reason:
            "it's not possible to create a campaign with an invalid start date",
      );
    });

    test("should throw exception if endDate is invalid", () {
      expect(
        () => validCampaign.copyWith(endDate: DateTime(1899)),
        throwsException,
        reason:
            "it's not possible to create a campaign with an invalid end date",
      );
    });

    test("should throw exception if endDate is after startDate", () {
      expect(
        () => validCampaign.copyWith(
          startDate: DateTime(2022),
          endDate: DateTime(2021),
        ),
        throwsException,
        reason:
            "it's not possible to create a campaign with end date after start date",
      );
    });
  });

  group("campaign model instances comparison", () {
    test("should return true if both instances are identical", () {
      final Campaign actualCampaign = validCampaign;

      expect(actualCampaign, validCampaign);
      expect(actualCampaign.hashCode, validCampaign.hashCode);
    });

    test("should return true if two campaigns are equal", () {
      final Campaign actualCampaign = validCampaign.copyWith();

      expect(actualCampaign, validCampaign);
    });

    test("should return false if two campaigns are not equal", () {
      final Campaign actualCampaign = validCampaign.copyWith(id: 2);

      expect(actualCampaign, isNot(validCampaign));
    });
  });
}
