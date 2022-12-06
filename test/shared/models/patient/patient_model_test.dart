import 'package:flutter_test/flutter_test.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';

void main() {
  late PriorityCategory expectedPriorityCategory;
  late PriorityGroup expectedPriorityGroup;
  late Patient validPatient;

  setUp(() {
    expectedPriorityGroup = PriorityGroup(
      id: 1,
      code: "Pessoas com mais de 60 anos",
    );
    expectedPriorityCategory = PriorityCategory(
      id: 1,
      priorityGroup: expectedPriorityGroup,
      code: "Pessoas idosas",
      name: "Idosos",
      description: "Categoria para pessoas idosas",
    );
    validPatient = Patient(
      id: 1,
      cns: "748477761910001",
      maternalCondition: MaternalCondition.gestante,
      priorityCategory: expectedPriorityCategory,
      person: Person(
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
      ),
    );
  });

  group('patient model valid instance creation', () {
    test('should create a valid instance', () {
      expect(validPatient, isA<Patient>());
      expect(validPatient.id, 1);
      expect(validPatient.cns, "748477761910001");
      expect(validPatient.maternalCondition, MaternalCondition.gestante);
      expect(validPatient.priorityCategory.id, 1);
      expect(validPatient.priorityCategory.code, "Pessoas idosas");
      expect(validPatient.person.id, 1);
      expect(validPatient.person.cpf, "67732120817");
      expect(validPatient.person.name, "Name Middlename Lastname");
      expect(validPatient.person.birthDate, DateTime(2000));
      expect(validPatient.person.locality!.id, 1);
      expect(validPatient.person.locality!.name, "Locality Name");
      expect(validPatient.person.locality!.city, "City Name");
      expect(validPatient.person.locality!.state, "State Name");
      expect(validPatient.person.locality!.ibgeCode, "1234567");
    });
  });

  group('patient model invalid instance creation', () {
    test("should throw exception if id is 0", () {
      expect(
        () => validPatient.copyWith(id: 0),
        throwsException,
        reason: "it's not possible to create a patient with id 0",
      );
    });

    test("should throw exception if id is negative", () {
      expect(
        () => validPatient.copyWith(id: -1),
        throwsException,
        reason: "it's not possible to create a patient with id -1",
      );
    });

    test("should throw exception if cns length != 15", () async {
      expect(
        () async => validPatient.copyWith(cns: "12345678901234"),
        throwsException,
      );

      expect(
        () async => validPatient.copyWith(cns: " 2345678901234 "),
        throwsException,
      );

      expect(
        () async => validPatient.copyWith(cns: "1234567890123456"),
        throwsException,
      );
    });

    test("should throw exception if cns has no numeric characters", () async {
      expect(
        () async => validPatient.copyWith(cns: "12345678901234A"),
        throwsException,
      );

      expect(
        () async => validPatient.copyWith(cns: "12 45 7890 2 45"),
        throwsException,
      );

      expect(
        () async => validPatient.copyWith(cns: "1-3/%6789_12+4*"),
        throwsException,
      );
    });

    test("should throw exception if cns is 0 * 15", () async {
      expect(
        () async => validPatient.copyWith(cns: "0" * 15),
        throwsException,
      );
    });

    test("should throw exception if cns is invalid", () async {
      String invalidRandomCns = "846359713320003";
      expect(
        () async => validPatient.copyWith(cns: invalidRandomCns),
        throwsException,
      );

      invalidRandomCns = "246359713320003";
      expect(
        () async => validPatient.copyWith(cns: invalidRandomCns),
        throwsException,
      );
    });
  });
  group('patient model instances comparison', () {
    test("should return true if both instances are identical", () {
      final actualPatient = validPatient;

      expect(actualPatient, validPatient);
      expect(actualPatient.hashCode, validPatient.hashCode);
    });

    test("should return true if two patients are equal", () {
      final actualPatient = validPatient.copyWith();

      expect(actualPatient, validPatient);
    });

    test("should return false if two patients are not equal", () {
      final actualPatient = validPatient.copyWith(id: 2);

      expect(actualPatient, isNot(validPatient));
    });
  });
}
