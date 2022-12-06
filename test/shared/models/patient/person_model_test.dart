import 'package:flutter_test/flutter_test.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';

void main() {
  late Person validPerson;

  setUp(() {
    validPerson = Person(
      id: 1,
      cpf: "67732120817",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: Locality(
        id: 1,
        name: "Locality Name",
        city: "City Name",
        state: "State Name",
        ibgeCode: "1234567",
      ),
    );
  });

  group('person model valid instance creation', () {
    test('should create a valid instance', () {
      expect(validPerson, isA<Person>());
      expect(validPerson.id, 1);
      expect(validPerson.cpf, "67732120817");
      expect(validPerson.name, "Name Middlename Lastname");
      expect(validPerson.birthDate, DateTime(2000));
      expect(validPerson.locality!.id, 1);
      expect(validPerson.locality!.name, "Locality Name");
      expect(validPerson.locality!.city, "City Name");
      expect(validPerson.locality!.state, "State Name");
      expect(validPerson.locality!.ibgeCode, "1234567");
    });
  });

  group('person model invalid instance creation', () {
    test("should throw exception if id is 0", () {
      expect(
        () => validPerson.copyWith(id: 0),
        throwsException,
        reason: "it's not possible to create a person with id 0",
      );
    });

    test("should throw exception if id is negative", () {
      expect(
        () => validPerson.copyWith(id: -1),
        throwsException,
        reason: "it's not possible to create a person with id -1",
      );
    });

    test("should throw exception if name is empty", () {
      expect(
        () => validPerson.copyWith(name: ""),
        throwsException,
        reason: "it's not possible to create a person with an empty name",
      );
    });

    test("should throw exception if name has only spaces", () {
      expect(
        () => validPerson.copyWith(name: "  "),
        throwsException,
        reason: "it's not possible to create a person with an invalid name",
      );
    });

    test("should throw exception if name has weird characters", () {
      expect(
        () => validPerson.copyWith(
            name: "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?"),
        throwsException,
        reason: "it's not possible to create a person with an invalid name",
      );
    });

    test("should throw exception if birthDate is invalid", () {
      expect(
        () => validPerson.copyWith(birthDate: DateTime(1899)),
        throwsException,
        reason: "it's not possible to create a person with an invalid birth",
      );

      expect(
        () => validPerson.copyWith(birthDate: DateTime(2100)),
        throwsException,
        reason: "it's not possible to create a person with an invalid birth",
      );
    });
  });
  group('person model instances comparison', () {
    test("should return true if both instances are identical", () {
      final actualPerson = validPerson;

      expect(actualPerson, validPerson);
      expect(actualPerson.hashCode, validPerson.hashCode);
    });

    test("should return true if two persons are equal", () {
      final actualPerson = validPerson.copyWith();

      expect(actualPerson, validPerson);
    });

    test("should return false if two persons are not equal", () {
      final actualPerson = validPerson.copyWith(id: 2);

      expect(actualPerson, isNot(validPerson));
    });
  });
}
