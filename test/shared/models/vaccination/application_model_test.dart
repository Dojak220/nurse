import "package:flutter_test/flutter_test.dart";
import "package:nurse/shared/models/infra/campaign_model.dart";
import "package:nurse/shared/models/infra/establishment_model.dart";
import "package:nurse/shared/models/infra/locality_model.dart";
import "package:nurse/shared/models/patient/patient_model.dart";
import "package:nurse/shared/models/patient/person_model.dart";
import "package:nurse/shared/models/patient/priority_category_model.dart";
import "package:nurse/shared/models/patient/priority_group_model.dart";
import "package:nurse/shared/models/vaccination/application_model.dart";
import "package:nurse/shared/models/vaccination/applier_model.dart";
import "package:nurse/shared/models/vaccination/vaccine_batch_model.dart";
import "package:nurse/shared/models/vaccination/vaccine_model.dart";

void main() {
  late Application validApplication;

  final expectedPriorityGroup = PriorityGroup(
    id: 1,
    code: "Pessoas com mais de 60 anos",
  );
  final expectedPriorityCategory = PriorityCategory(
    id: 1,
    priorityGroup: expectedPriorityGroup,
    code: "Pessoas idosas",
    name: "Idosos",
    description: "Categoria para pessoas idosas",
  );
  final expectedLocality = Locality(
    id: 1,
    name: "Locality Name",
    city: "City Name",
    state: "State Name",
    ibgeCode: "1234567",
  );

  final expectedVaccineBatch = VaccineBatch(
    id: 1,
    number: "01234",
    quantity: 10,
    vaccine: Vaccine(
      id: 1,
      sipniCode: "123456",
      name: "Vaccine Name",
      laboratory: "Laboratory Name",
    ),
  );

  final expectedPatient = Patient(
    id: 1,
    cns: "748477761910001",
    maternalCondition: MaternalCondition.gestante,
    priorityCategory: expectedPriorityCategory,
    person: Person(
      id: 1,
      cpf: "67732120817",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: expectedLocality,
    ),
  );

  final expectedApplier = Applier(
    id: 1,
    cns: "279197866950004",
    person: Person(
      id: 1,
      cpf: "82675387630",
      name: "Name Middlename Lastname",
      birthDate: DateTime(2000),
      locality: expectedLocality,
    ),
    establishment: Establishment(
      id: 1,
      cnes: "1234567",
      name: "Old Name",
      locality: Locality(
        id: 1,
        name: "Locality Name",
        city: "City Name",
        state: "State Name",
        ibgeCode: "1234567",
      ),
    ),
  );

  setUp(() {
    validApplication = Application(
      id: 1,
      patient: expectedPatient,
      vaccineBatch: expectedVaccineBatch,
      applicationDate: DateTime(2022, 3, 4),
      applier: expectedApplier,
      dose: VaccineDose.d1,
      campaign: Campaign(
        id: 1,
        title: "Campaign Title",
        startDate: DateTime(2022),
      ),
      dueDate: DateTime(2022, 4),
    );
  });

  group("application model valid instance creation", () {
    test("should create a valid instance", () {
      expect(validApplication, isA<Application>());
      expect(validApplication.id, 1);

      expect(validApplication.applicationDate, DateTime(2022, 3, 4));
      expect(validApplication.dose, VaccineDose.d1);
      expect(validApplication.dueDate, DateTime(2022, 4));
    });

    test("should create a valid instance if dueDate is null", () {
      final Application actualApplication = validApplication.copyWith(
        applicationDate: DateTime(2022),
      );

      expect(actualApplication.id, 1);
      expect(
        actualApplication.dueDate,
        DateTime(2022).add(const Duration(days: 3 * 30)),
      );
    });
  });

  group("application model invalid instance creation", () {
    test("should throw exception if id is 0", () {
      expect(
        () => validApplication.copyWith(id: 0),
        throwsException,
        reason: "it's not possible to create a application with id 0",
      );
    });

    test("should throw exception if id is negative", () {
      expect(
        () => validApplication.copyWith(id: -1),
        throwsException,
        reason: "it's not possible to create a application with id -1",
      );
    });

    test("should throw exception if applicationDate is invalid", () {
      expect(
        () => validApplication.copyWith(applicationDate: DateTime(1899)),
        throwsException,
        reason:
            "it's not possible to create an application with an invalid date",
      );

      expect(
        () => validApplication.copyWith(applicationDate: DateTime(2100)),
        throwsException,
        reason:
            "it's not possible to create an application with an invalid date",
      );
    });
  });
  group("application model instances comparison", () {
    test("should return true if both instances are identical", () {
      final Application actualApplication = validApplication;

      expect(actualApplication, validApplication);
      expect(actualApplication.hashCode, validApplication.hashCode);
    });

    test("should return true if two applications are equal", () {
      final Application actualApplication = validApplication.copyWith();

      expect(actualApplication, validApplication);
    });

    test("should return false if two applications are not equal", () {
      final Application actualApplication = validApplication.copyWith(id: 2);

      expect(actualApplication, isNot(validApplication));
    });
  });
}
