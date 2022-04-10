import 'package:flutter_test/flutter_test.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/models/patient/vaccination_card_model.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';

void main() {
  late VaccinationCard validVaccinationCard;
  final expectedLocality = Locality(
    id: 1,
    name: "Locality Name",
    city: "City Name",
    state: "State Name",
    ibgeCode: "1234567",
  );
  final expectedPatient = Patient(
    id: 1,
    cns: "748477761910001",
    maternalCondition: MaternalCondition.GESTANTE,
    priorityGroup: PriorityGroup(
      id: 1,
      groupCode: "Pessoas com mais de 60 anos",
    ),
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

  final expectedApplications = [
    Application(
      id: 1,
      patient: expectedPatient,
      applicationDate: DateTime.now().subtract(Duration(days: 4 * 30)),
      applier: expectedApplier,
      vaccineBatch: VaccineBatch(
        id: 1,
        batchNo: "123456",
        quantity: 20,
      ),
      vaccineDose: VaccineDose.D1,
      campaign: Campaign(
        id: 1,
        title: "Campaign Title",
        startDate: DateTime(2022),
      ),
      dueDate: DateTime(2024),
    ),
    Application(
      id: 2,
      patient: expectedPatient,
      applicationDate: DateTime.now(),
      applier: expectedApplier,
      vaccineBatch: VaccineBatch(
        id: 2,
        batchNo: "789012",
        quantity: 20,
      ),
      vaccineDose: VaccineDose.D2,
      campaign: Campaign(
        id: 1,
        title: "Campaign Title",
        startDate: DateTime(2022),
      ),
      dueDate: DateTime(2024),
    )
  ];

  setUp(() {
    validVaccinationCard =
        VaccinationCard(id: 1, applications: expectedApplications);
  });

  group('vaccinationCard model valid intance creation', () {
    test('should create a valid instance', () {
      expect(validVaccinationCard, isA<VaccinationCard>());
      expect(validVaccinationCard.id, 1);

      expect(validVaccinationCard.applications.length, 2);
      expect(validVaccinationCard.applications[0].id, 1);
      expect(validVaccinationCard.applications[1].id, 2);
    });
  });

  group('vaccinationCard model invalid intance creation', () {
    test("should throw exception if id is 0", () {
      expect(
        () => validVaccinationCard.copyWith(id: 0),
        throwsException,
        reason: "it's not possible to create a vaccinationCard with id 0",
      );
    });

    test("should throw exception if id is negative", () {
      expect(
        () => validVaccinationCard.copyWith(id: -1),
        throwsException,
        reason: "it's not possible to create a vaccinationCard with id -1",
      );
    });

    test("should throw exception if applications is empty", () {
      expect(
        () => validVaccinationCard.copyWith(applications: []),
        throwsException,
        reason:
            "it's not possible to create a vaccinationCard with applications empty",
      );
    });
  });
}
