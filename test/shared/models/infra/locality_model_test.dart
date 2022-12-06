import 'package:flutter_test/flutter_test.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';

void main() {
  late Locality validLocality;

  setUp(() {
    validLocality = Locality(
      id: 1,
      name: "Locality Name",
      city: "City Name",
      state: "State Name",
      ibgeCode: "1234567",
    );
  });

  group('locality model valid instance creation', () {
    test('should create a valid instance', () {
      expect(validLocality, isA<Locality>());
      expect(validLocality.id, 1);
      expect(validLocality.name, "Locality Name");
      expect(validLocality.city, "City Name");
      expect(validLocality.state, "State Name");
      expect(validLocality.ibgeCode, "1234567");
    });
  });

  group('locality model invalid instance creation', () {
    test("should throw exception if id is 0", () {
      expect(
        () => validLocality.copyWith(id: 0),
        throwsException,
        reason: "it's not possible to create a locality with id 0",
      );
    });

    test("should throw exception if id is negative", () {
      expect(
        () => validLocality.copyWith(id: -1),
        throwsException,
        reason: "it's not possible to create a locality with id -1",
      );
    });

    test("should throw exception if name is empty", () {
      expect(
        () => validLocality.copyWith(name: ""),
        throwsException,
        reason: "it's not possible to create a locality with an empty name",
      );
    });

    test("should throw exception if name has only spaces", () {
      expect(
        () => validLocality.copyWith(name: "  "),
        throwsException,
        reason: "it's not possible to create a locality with an invalid name",
      );
    });

    test("should throw exception if name has weird characters", () {
      expect(
        () => validLocality.copyWith(
            name: "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?"),
        throwsException,
        reason: "it's not possible to create a locality with an invalid name",
      );
    });

    test("should throw exception if city is empty", () {
      expect(
        () => validLocality.copyWith(city: ""),
        throwsException,
        reason: "it's not possible to create a locality with an empty city",
      );
    });

    test("should throw exception if city has only spaces", () {
      expect(
        () => validLocality.copyWith(city: "  "),
        throwsException,
        reason: "it's not possible to create a locality with an invalid city",
      );
    });

    test("should throw exception if city has weird characters", () {
      expect(
        () => validLocality.copyWith(
            city: "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?"),
        throwsException,
        reason: "it's not possible to create a locality with an invalid city",
      );
    });

    test("should throw exception if state is empty", () {
      expect(
        () => validLocality.copyWith(state: ""),
        throwsException,
        reason: "it's not possible to create a locality with an empty state",
      );
    });

    test("should throw exception if state has only spaces", () {
      expect(
        () => validLocality.copyWith(state: "  "),
        throwsException,
        reason: "it's not possible to create a locality with an invalid state",
      );
    });

    test("should throw exception if state has weird characters", () {
      expect(
        () => validLocality.copyWith(
            state:
                "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?"),
        throwsException,
        reason: "it's not possible to create a locality with an invalid state",
      );
    });

    test("should throw exception if ibgeCode is invalid", () {
      expect(
        () => validLocality.copyWith(ibgeCode: ""),
        throwsException,
        reason:
            "it's not possible to create a locality with an invalid ibgeCode",
      );

      expect(
        () => validLocality.copyWith(ibgeCode: " " * 7),
        throwsException,
        reason:
            "it's not possible to create a locality with an invalid ibgeCode",
      );

      expect(
        () => validLocality.copyWith(ibgeCode: "1bcdef7"),
        throwsException,
        reason:
            "it's not possible to create a locality with an invalid ibgeCode",
      );

      expect(
        () => validLocality.copyWith(ibgeCode: "123456"),
        throwsException,
        reason:
            "it's not possible to create a locality with an invalid ibgeCode",
      );

      expect(
        () => validLocality.copyWith(ibgeCode: "12345678"),
        throwsException,
        reason:
            "it's not possible to create a locality with an invalid ibgeCode",
      );
    });
  });
  group('locality model instances comparison', () {
    test("should return true if both instances are identical", () {
      final actualLocality = validLocality;

      expect(actualLocality, validLocality);
      expect(actualLocality.hashCode, validLocality.hashCode);
    });

    test("should return true if two localities are equal", () {
      final actualLocality = validLocality.copyWith();

      expect(actualLocality, validLocality);
    });

    test("should return false if two localities are not equal", () {
      final actualLocality = validLocality.copyWith(id: 2);

      expect(actualLocality, isNot(validLocality));
    });
  });
}
