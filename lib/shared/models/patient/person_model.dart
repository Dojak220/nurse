import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Person implements GenericModel {
  @override
  final int id;
  final String cpf;
  final String name;
  final DateTime birthDate;
  final Locality locality;
  final Gender gender; //or sex?
  final String motherName;
  final String fatherName;

  Person({
    required this.id,
    required this.cpf,
    required this.name,
    required this.birthDate,
    required this.locality,
    this.gender = Gender.NONE,
    this.motherName = "",
    this.fatherName = "",
  }) {
    Validator.validateAll([
      ValidationPair(ValidatorType.CPF, cpf),
      ValidationPair(ValidatorType.String, name),
      ValidationPair(ValidatorType.String, motherName),
      ValidationPair(ValidatorType.String, fatherName),
      ValidationPair(ValidatorType.BirthDate, birthDate),
    ]);
  }
}

enum Gender { FEMALE, MALE, NONE }
