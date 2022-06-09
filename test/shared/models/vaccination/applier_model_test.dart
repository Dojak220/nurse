import 'package:flutter_test/flutter_test.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';

void main() {
  late Applier validApplier;

  setUp(() {
    final expectedLocality = Locality(
      id: 1,
      name: "Locality Name",
      city: "City Name",
      state: "State Name",
      ibgeCode: "1234567",
    );

    validApplier = Applier(
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
        ));
  });

  group('applier model valid intance creation', () {
    test('should create a valid instance', () {
      expect(validApplier, isA<Applier>());
      expect(validApplier.id, 1);
      expect(validApplier.cns, "279197866950004");

      expect(validApplier.person.id, 1);
      expect(validApplier.person.cpf, "82675387630");
      expect(validApplier.person.name, "Name Middlename Lastname");
      expect(validApplier.person.birthDate, DateTime(2000));
      expect(validApplier.person.locality!.id, 1);
      expect(validApplier.person.locality!.name, "Locality Name");
      expect(validApplier.person.locality!.city, "City Name");
      expect(validApplier.person.locality!.state, "State Name");
      expect(validApplier.person.locality!.ibgeCode, "1234567");
    });
  });

  group('applier model invalid intance creation', () {
    test("should throw exception if id is 0", () {
      expect(
        () => validApplier.copyWith(id: 0),
        throwsException,
        reason: "it's not possible to create a applier with id 0",
      );
    });

    test("should throw exception if id is negative", () {
      expect(
        () => validApplier.copyWith(id: -1),
        throwsException,
        reason: "it's not possible to create a applier with id -1",
      );
    });

    test("should throw exception if cns length != 15", () async {
      expect(
        () async => validApplier.copyWith(cns: "12345678901234"),
        throwsException,
      );

      expect(
        () async => validApplier.copyWith(cns: " 2345678901234 "),
        throwsException,
      );

      expect(
        () async => validApplier.copyWith(cns: "1234567890123456"),
        throwsException,
      );
    });

    test("should throw exception if cns has no numeric characters", () async {
      expect(
        () async => validApplier.copyWith(cns: "12345678901234A"),
        throwsException,
      );

      expect(
        () async => validApplier.copyWith(cns: "12 45 7890 2 45"),
        throwsException,
      );

      expect(
        () async => validApplier.copyWith(cns: "1-3/%6789_12+4*"),
        throwsException,
      );
    });

    test("should throw exception if cns is 0 * 15", () async {
      expect(
        () async => validApplier.copyWith(cns: "0" * 15),
        throwsException,
      );
    });

    test("should throw exception if cns is invalid", () async {
      String invalidRandomCns = "846359713320003";
      expect(
        () async => validApplier.copyWith(cns: invalidRandomCns),
        throwsException,
      );

      invalidRandomCns = "246359713320003";
      expect(
        () async => validApplier.copyWith(cns: invalidRandomCns),
        throwsException,
      );
    });
  });
}
