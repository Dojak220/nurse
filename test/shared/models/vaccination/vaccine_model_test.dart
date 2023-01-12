import "package:flutter_test/flutter_test.dart";
import "package:nurse/shared/models/vaccination/vaccine_model.dart";

void main() {
  late Vaccine validVaccine;

  setUp(() {
    validVaccine = Vaccine(
      id: 1,
      sipniCode: "123456",
      name: "Vaccine Name",
      laboratory: "Laboratory Name",
    );
  });

  group("vaccine model valid instance creation", () {
    test("should create a valid instance", () {
      expect(validVaccine, isA<Vaccine>());
      expect(validVaccine.id, 1);
      expect(validVaccine.sipniCode, "123456");
      expect(validVaccine.name, "Vaccine Name");
      expect(validVaccine.laboratory, "Laboratory Name");
    });
  });

  group("vaccine model invalid instance creation", () {
    test("should throw exception if id is 0", () {
      expect(
        () => validVaccine.copyWith(id: 0),
        throwsException,
        reason: "it's not possible to create a vaccine with id 0",
      );
    });

    test("should throw exception if id is negative", () {
      expect(
        () => validVaccine.copyWith(id: -1),
        throwsException,
        reason: "it's not possible to create a vaccine with id -1",
      );
    });

    test("should throw exception if sipniCode is empty", () {
      expect(
        () => validVaccine.copyWith(sipniCode: ""),
        throwsException,
        reason: "it's not possible to create a vaccine with an empty sipniCode",
      );
    });

    test("should throw exception if sipniCode has only spaces", () {
      expect(
        () => validVaccine.copyWith(sipniCode: "  "),
        throwsException,
        reason:
            "it's not possible to create a vaccine with an invalid sipniCode",
      );
    });

    test("should throw exception if sipniCode has weird characters", () {
      expect(
        () => validVaccine.copyWith(
          sipniCode:
              "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?",
        ),
        throwsException,
        reason:
            "it's not possible to create a vaccine with an invalid sipniCode",
      );
    });

    test("should throw exception if name is empty", () {
      expect(
        () => validVaccine.copyWith(name: ""),
        throwsException,
        reason: "it's not possible to create a vaccine with an empty name",
      );
    });

    test("should throw exception if name has only spaces", () {
      expect(
        () => validVaccine.copyWith(name: "  "),
        throwsException,
        reason: "it's not possible to create a vaccine with an invalid name",
      );
    });

    test("should throw exception if name has weird characters", () {
      expect(
        () => validVaccine.copyWith(
          name: "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?",
        ),
        throwsException,
        reason: "it's not possible to create a vaccine with an invalid name",
      );
    });

    test("should throw exception if laboratory is empty", () {
      expect(
        () => validVaccine.copyWith(laboratory: ""),
        throwsException,
        reason:
            "it's not possible to create a vaccine with an empty laboratory",
      );
    });

    test("should throw exception if laboratory has only spaces", () {
      expect(
        () => validVaccine.copyWith(laboratory: "  "),
        throwsException,
        reason:
            "it's not possible to create a vaccine with an invalid laboratory",
      );
    });

    test("should throw exception if laboratory has weird characters", () {
      expect(
        () => validVaccine.copyWith(
          laboratory:
              "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?",
        ),
        throwsException,
        reason:
            "it's not possible to create a vaccine with an invalid laboratory",
      );
    });
  });
  group("vaccine model instances comparison", () {
    test("should return true if both instances are identical", () {
      final Vaccine actualVaccine = validVaccine;

      expect(actualVaccine, validVaccine);
      expect(actualVaccine.hashCode, validVaccine.hashCode);
    });

    test("should return true if two vaccines are equal", () {
      final Vaccine actualVaccine = validVaccine.copyWith();

      expect(actualVaccine, validVaccine);
    });

    test("should return false if two vaccines are not equal", () {
      final Vaccine actualVaccine = validVaccine.copyWith(id: 2);

      expect(actualVaccine, isNot(validVaccine));
    });
  });
}
