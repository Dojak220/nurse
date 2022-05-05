import 'package:flutter_test/flutter_test.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';

void main() {
  late PriorityGroup validPriorityGroup;

  setUp(() {
    validPriorityGroup = PriorityGroup(
      id: 1,
      code: "Pessoas com mais de 60 anos",
      name: "Idosos",
      description: "Grupo de pessoas com mais de 60 anos",
    );
  });

  group('priorityGroup model valid intance creation', () {
    test('should create a valid instance', () {
      expect(validPriorityGroup, isA<PriorityGroup>());
      expect(validPriorityGroup.id, 1);
      expect(validPriorityGroup.code, "Pessoas com mais de 60 anos");
      expect(validPriorityGroup.name, "Idosos");
      expect(
        validPriorityGroup.description,
        "Grupo de pessoas com mais de 60 anos",
      );
    });

    test("should return a priority group with description empty", () {
      final actualPriorityGroup = validPriorityGroup.copyWith(description: "");

      expect(actualPriorityGroup.description, "");
    });

    test(
        "should return a priority group with description empty if description has only spaces",
        () {
      final actualPriorityGroup = validPriorityGroup.copyWith(description: " ");

      expect(actualPriorityGroup.description, "");
    });

    test(
        "should return a priority group with groupCode and name equals when name is empty",
        () {
      final actualPriorityGroup = validPriorityGroup.copyWith(name: "");

      expect(actualPriorityGroup.name, actualPriorityGroup.code);
      expect(actualPriorityGroup.name, validPriorityGroup.code);
    });
  });

  group('priorityGroup model invalid intance creation', () {
    test("should throw exception if id is 0", () {
      expect(
        () => validPriorityGroup.copyWith(id: 0),
        throwsException,
        reason: "it's not possible to create a priorityGroup with id 0",
      );
    });

    test("should throw exception if id is negative", () {
      expect(
        () => validPriorityGroup.copyWith(id: -1),
        throwsException,
        reason: "it's not possible to create a priorityGroup with id -1",
      );
    });

    test("should throw exception if groupCode is empty", () {
      expect(
        () => validPriorityGroup.copyWith(code: ""),
        throwsException,
        reason:
            "it's not possible to create a priorityGroup with an empty groupCode",
      );
    });

    test("should throw exception if groupCode has only spaces", () {
      expect(
        () => validPriorityGroup.copyWith(code: "  "),
        throwsException,
        reason:
            "it's not possible to create a priorityGroup with an invalid groupCode",
      );
    });

    test("should throw exception if groupCode has weird characters", () {
      expect(
        () => validPriorityGroup.copyWith(
            code: "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?"),
        throwsException,
        reason:
            "it's not possible to create a priorityGroup with an invalid groupCode",
      );
    });

    test("should throw exception if name has only spaces", () {
      expect(
        () => validPriorityGroup.copyWith(name: "  "),
        throwsException,
        reason:
            "it's not possible to create a priorityGroup with an invalid name",
      );
    });

    test("should throw exception if name has weird characters", () {
      expect(
        () => validPriorityGroup.copyWith(
            name: "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?"),
        throwsException,
        reason:
            "it's not possible to create a priorityGroup with an invalid name",
      );
    });

    test("should throw exception if description has weird characters", () {
      expect(
        () => validPriorityGroup.copyWith(
            description:
                "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?"),
        throwsException,
        reason:
            "it's not possible to create a priorityGroup with an invalid description",
      );
    });
  });
}
