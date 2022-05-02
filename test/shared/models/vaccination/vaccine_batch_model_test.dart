import 'package:flutter_test/flutter_test.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';

void main() {
  late VaccineBatch validVaccineBatch;

  setUp(() {
    validVaccineBatch = VaccineBatch(
      id: 1,
      batchNo: "01234",
      quantity: 10,
    );
  });

  group('vaccineBatch model valid intance creation', () {
    test('should create a valid instance', () {
      expect(validVaccineBatch, isA<VaccineBatch>());
      expect(validVaccineBatch.id, 1);
      expect(validVaccineBatch.batchNo, "01234");
      expect(validVaccineBatch.quantity, 10);
    });
  });

  group('vaccineBatch model invalid intance creation', () {
    test("should throw exception if id is 0", () {
      expect(
        () => validVaccineBatch.copyWith(id: 0),
        throwsException,
        reason: "it's not possible to create a vaccineBatch with id 0",
      );
    });

    test("should throw exception if id is negative", () {
      expect(
        () => validVaccineBatch.copyWith(id: -1),
        throwsException,
        reason: "it's not possible to create a vaccineBatch with id -1",
      );
    });

    test("should throw exception if batchNo is empty", () {
      expect(
        () => validVaccineBatch.copyWith(batchNo: ""),
        throwsException,
        reason:
            "it's not possible to create a vaccineBatch with an empty batchNo",
      );
    });

    test("should throw exception if batchNo has only spaces", () {
      expect(
        () => validVaccineBatch.copyWith(batchNo: "  "),
        throwsException,
        reason:
            "it's not possible to create a vaccineBatch with an invalid batchNo",
      );
    });

    test("should throw exception if batchNo is non numerical", () {
      expect(
        () => validVaccineBatch.copyWith(batchNo: "abcdef"),
        throwsException,
        reason:
            "it's not possible to create a vaccineBatch with a non numerical batchNo",
      );
    });

    test("should throw exception if batchNo has weird characters", () {
      expect(
        () => validVaccineBatch.copyWith(
            batchNo:
                "\\ ! ? @ # \$ % ¨ & * + § = ^ ~ ` ´ { } ; : ' \" , . < > ?"),
        throwsException,
        reason:
            "it's not possible to create a vaccineBatch with an invalid batchNo",
      );
    });

    test("should throw exception if quantity is 0", () {
      expect(
        () => validVaccineBatch.copyWith(quantity: 0),
        throwsException,
        reason: "it's not possible to create a vaccineBatch with quantity 0",
      );
    });

    test("should throw exception if quantity is negative", () {
      expect(
        () => validVaccineBatch.copyWith(quantity: -1),
        throwsException,
        reason: "it's not possible to create a vaccineBatch with quantity -1",
      );
    });
  });
}
