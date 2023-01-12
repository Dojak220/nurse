import "package:flutter_test/flutter_test.dart";
import "package:nurse/shared/models/infra/establishment_model.dart";
import "package:nurse/shared/models/infra/locality_model.dart";

void main() {
  late Locality expectedLocality;
  late Establishment validEstablishment;

  setUp(() {
    expectedLocality = Locality(
      id: 1,
      name: "Local",
      city: "Brasília",
      state: "DF",
      ibgeCode: "1234567",
    );

    validEstablishment = Establishment(
      id: 1,
      cnes: "1234567",
      name: "Establishment Name",
      locality: expectedLocality,
    );
  });

  group("establishment model valid instance creation", () {
    test("should create a valid instance", () {
      expect(validEstablishment, isA<Establishment>());
      expect(validEstablishment.id, 1);
      expect(validEstablishment.cnes, "1234567");
      expect(validEstablishment.name, "Establishment Name");
      expect(validEstablishment.locality, expectedLocality);
    });
  });

  group("establishment model invalid instance creation", () {
    test("should throw exception if id is 0", () async {
      expect(
        () async => validEstablishment.copyWith(id: 0),
        throwsException,
        reason: "it's not possible to create an establishment with id 0",
      );
    });

    test("should throw exception if id is negative", () async {
      expect(
        () async => validEstablishment.copyWith(id: -1),
        throwsException,
      );
    });

    test("should throw exception if cnes length != 7", () async {
      expect(
        () async => validEstablishment.copyWith(cnes: "123456"),
        throwsException,
      );

      expect(
        () async => validEstablishment.copyWith(cnes: " 23456 "),
        throwsException,
      );

      expect(
        () async => validEstablishment.copyWith(cnes: "123456789"),
        throwsException,
      );
    });

    test("should throw exception if cnes has no numeric characters", () async {
      expect(
        () async => validEstablishment.copyWith(cnes: "123456A"),
        throwsException,
      );

      expect(
        () async => validEstablishment.copyWith(cnes: "12 45 7"),
        throwsException,
      );
    });

    test("should throw exception if name is empty", () async {
      expect(
        () async => validEstablishment.copyWith(name: ""),
        throwsException,
      );
    });

    test("should throw exception if name has only spaces", () async {
      expect(
        () async => validEstablishment.copyWith(name: "   "),
        throwsException,
      );
    });

    test("should throw exception if name has weird characters", () async {
      expect(
        () async => validEstablishment.copyWith(
          name: "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?",
        ),
        throwsException,
      );
    });
  });
  group("establishment model instances comparison", () {
    test("should return true if both instances are identical", () {
      final Establishment actualEstablishment = validEstablishment;

      expect(actualEstablishment, validEstablishment);
      expect(actualEstablishment.hashCode, validEstablishment.hashCode);
    });

    test("should return true if two establishments are equal", () {
      final Establishment actualEstablishment = validEstablishment.copyWith();

      expect(actualEstablishment, validEstablishment);
    });

    test("should return false if two establishments are not equal", () {
      final Establishment actualEstablishment =
          validEstablishment.copyWith(id: 2);

      expect(actualEstablishment, isNot(validEstablishment));
    });
  });
}
