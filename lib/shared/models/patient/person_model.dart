import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Person implements GenericModel {
  @override
  final int? id;
  final String cpf;
  final String name;
  final DateTime birthDate;
  final Locality locality;
  final Sex sex;
  final String motherName;
  final String fatherName;

  Person({
    this.id,
    required this.cpf,
    required this.name,
    required this.birthDate,
    required this.locality,
    this.sex = Sex.NONE,
    this.motherName = "",
    this.fatherName = "",
  }) {
    Validator.validateAll([
      ValidationPair(ValidatorType.CPF, this.cpf),
      ValidationPair(ValidatorType.Name, this.name),
      ValidationPair(ValidatorType.OptionalName, this.motherName),
      ValidationPair(ValidatorType.OptionalName, this.fatherName),
      ValidationPair(ValidatorType.BirthDate, this.birthDate),
    ]);
  }

  Person copyWith({
    int? id,
    String? cpf,
    String? name,
    DateTime? birthDate,
    Locality? locality,
    Sex? sex,
    String? motherName,
    String? fatherName,
  }) {
    return Person(
      id: id ?? this.id,
      cpf: cpf ?? this.cpf,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      locality: locality ?? this.locality,
      sex: sex ?? this.sex,
      motherName: motherName ?? this.motherName,
      fatherName: fatherName ?? this.fatherName,
    );
  }

  @override
  Map<String, Object> toMap() {
    return {
      'id': id ?? 0,
      'cpf': cpf,
      'name': name,
      'birth_date': birthDate.toString(),
      'locality': locality.toMap(),
      'sex': sex.name,
      'mother_name': motherName,
      'father_name': fatherName,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      cpf: map['cpf'] ?? "",
      name: map['name'] ?? '',
      birthDate: DateTime.parse(map['birth_date']),
      locality: Locality.fromMap(map['locality']),
      sex: SexExtension.fromString(map['sex'] ?? Sex.NONE.name),
      motherName: map['mother_name'] ?? '',
      fatherName: map['father_name'] ?? '',
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
        other.sex == sex &&
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
        sex.hashCode ^
        motherName.hashCode ^
        fatherName.hashCode;
  }

  @override
  String toString() {
    return 'Person(id: $id, cpf: $cpf, name: $name, birthDate: $birthDate, locality: $locality, sex: ${sex.name}, motherName: $motherName, fatherName: $fatherName)';
  }
}

enum Sex { FEMALE, MALE, NONE }

extension SexExtension on Sex {
  static Sex fromString(String value) {
    switch (value.toUpperCase()) {
      case "F":
      case "FEMALE":
      case "FEMININO":
        return Sex.FEMALE;
      case "M":
      case "MALE":
      case "MASCULINO":
        return Sex.MALE;
      case "N":
      case "NONE":
      case "NENHUM":
      default:
        return Sex.NONE;
    }
  }
}
