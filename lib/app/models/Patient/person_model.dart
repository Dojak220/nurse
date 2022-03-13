import 'package:nurse/app/models/Infra/locality_model.dart';

class PersonModel {
  final String cpf;
  final String name;
  final DateTime birthDate;
  final LocalityModel locality;
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
  });
}