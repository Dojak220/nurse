import 'package:flutter_test/flutter_test.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';

void main() {
  late PriorityGroup expectedPriorityGroup;
  late PriorityCategory validPriorityCategory;

  setUp(() {
    expectedPriorityGroup = PriorityGroup(
      id: 1,
      code: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );

    validPriorityCategory = PriorityCategory(
      id: 1,
      priorityGroup: expectedPriorityGroup,
      code: "Pessoas idosas",
      name: "Idosos",
      description: "Categoria para pessoas idosas",
    );
  });

  group('priorityCategory model valid intance creation', () {
    test('should create a valid instance', () {
      expect(validPriorityCategory, isA<PriorityCategory>());
      expect(validPriorityCategory.id, 1);
      expect(validPriorityCategory.priorityGroup, expectedPriorityGroup);
      expect(validPriorityCategory.code, "Pessoas idosas");
      expect(validPriorityCategory.name, "Idosos");
      expect(
        validPriorityCategory.description,
        "Categoria para pessoas idosas",
      );

      expect(expectedPriorityGroup, isA<PriorityGroup>());
      expect(expectedPriorityGroup.id, 1);
      expect(expectedPriorityGroup.code, "Pessoas com mais de 60 anos");
      expect(expectedPriorityGroup.name, "Idosos");
      expect(
        expectedPriorityGroup.description,
        "Grupo de pessoas com mais de 60 anos",
      );
    });

    test("should return a priority category with description empty", () {
      final actualPriorityCategory =
          validPriorityCategory.copyWith(description: "");

      expect(actualPriorityCategory.description, "");
    });

    test(
        "should return a priority category with categoryCode and name equals when name is empty",
        () {
      final actualPriorityCategory = validPriorityCategory.copyWith(name: "");

      expect(actualPriorityCategory.name, actualPriorityCategory.code);
      expect(actualPriorityCategory.name, validPriorityCategory.code);
    });

    test(
        "should return a priority category with description empty if description has only spaces",
        () {
      final actualPriorityGroup =
          validPriorityCategory.copyWith(description: " ");

      expect(actualPriorityGroup.description, "");
    });
  });

  group('priorityCategory model invalid intance creation', () {
    test("should throw exception if id is 0", () {
      expect(
        () => validPriorityCategory.copyWith(id: 0),
        throwsException,
        reason: "it's not possible to create a priorityCategory with id 0",
      );
    });

    test("should throw exception if id is negative", () {
      expect(
        () => validPriorityCategory.copyWith(id: -1),
        throwsException,
        reason: "it's not possible to create a priorityCategory with id -1",
      );
    });

    test("should throw exception if categoryCode is empty", () {
      expect(
        () => validPriorityCategory.copyWith(code: ""),
        throwsException,
        reason:
            "it's not possible to create a priorityCategory with an empty categoryCode",
      );
    });

    test("should throw exception if categoryCode has only spaces", () {
      expect(
        () => validPriorityCategory.copyWith(code: "  "),
        throwsException,
        reason:
            "it's not possible to create a priorityCategory with an invalid categoryCode",
      );
    });

    test("should throw exception if categoryCode has weird characters", () {
      expect(
        () => validPriorityCategory.copyWith(
            code: "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?"),
        throwsException,
        reason:
            "it's not possible to create a priorityCategory with an invalid categoryCode",
      );
    });

    test("should throw exception if name has only spaces", () {
      expect(
        () => validPriorityCategory.copyWith(name: "  "),
        throwsException,
        reason:
            "it's not possible to create a priorityCategory with an invalid name",
      );
    });

    test("should throw exception if name has weird characters", () {
      expect(
        () => validPriorityCategory.copyWith(
            name: "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?"),
        throwsException,
        reason:
            "it's not possible to create a priorityCategory with an invalid name",
      );
    });

    test("should throw exception if description has weird characters", () {
      expect(
        () => validPriorityCategory.copyWith(
            description:
                "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?"),
        throwsException,
        reason:
            "it's not possible to create a priorityCategory with an invalid description",
      );
    });
  });
}
