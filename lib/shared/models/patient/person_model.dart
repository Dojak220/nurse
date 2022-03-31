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
      ValidationPair(ValidatorType.Id, id),
      ValidationPair(ValidatorType.CPF, cpf),
      ValidationPair(ValidatorType.Name, name),
      ValidationPair(ValidatorType.OptionalName, motherName),
      ValidationPair(ValidatorType.OptionalName, fatherName),
      ValidationPair(ValidatorType.BirthDate, birthDate),
    ]);
  }

  Person copyWith({
    int? id,
    String? cpf,
    String? name,
    DateTime? birthDate,
    Locality? locality,
    Gender? gender,
    String? motherName,
    String? fatherName,
  }) {
    return Person(
      id: id ?? this.id,
      cpf: cpf ?? this.cpf,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      locality: locality ?? this.locality,
      gender: gender ?? this.gender,
      motherName: motherName ?? this.motherName,
      fatherName: fatherName ?? this.fatherName,
    );
  }

  @override
  Map<String, Object> toMap() {
    return {
      'id': id,
      'cpf': cpf,
      'name': name,
      'birthDate': birthDate.millisecondsSinceEpoch,
      'locality': locality.toMap(),
      'gender': gender,
      'motherName': motherName,
      'fatherName': fatherName,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id']?.toInt() ?? 0,
      cpf: map['cpf']?.toInt() ?? 0,
      name: map['name'] ?? '',
      birthDate: DateTime.fromMillisecondsSinceEpoch(map['birthDate']),
      locality: Locality.fromMap(map['locality']),
      gender: map['gender'] ?? '',
      motherName: map['motherName'] ?? '',
      fatherName: map['fatherName'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Person &&
        other.id == id &&
        other.cpf == cpf &&
        other.name == name &&
        other.birthDate == birthDate &&
        other.locality == locality &&
        other.gender == gender &&
        other.motherName == motherName &&
        other.fatherName == fatherName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cpf.hashCode ^
        name.hashCode ^
        birthDate.hashCode ^
        locality.hashCode ^
        gender.hashCode ^
        motherName.hashCode ^
        fatherName.hashCode;
  }
}

enum Gender { FEMALE, MALE, NONE }
