import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class PersonModel {
  final String cpf;
  final String name;
  final DateTime birthDate;
  final Locality locality;
  final String gender; //or sex?
  final String motherName;
  final String fatherName;

  PersonModel({
    required this.cpf,
    required this.name,
    required this.birthDate,
    required this.locality,
    this.gender = "",
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
