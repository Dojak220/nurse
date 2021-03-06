import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Person implements GenericModel {
  @override
  final int? id;
  final String cpf;
  final String name;
  final DateTime? birthDate;
  final Locality? locality;
  final Sex sex;
  final String motherName;
  final String fatherName;

  Person({
    this.id,
    required this.cpf,
    required String name,
    this.birthDate,
    this.locality,
    this.sex = Sex.NONE,
    String motherName = "",
    String fatherName = "",
  })  : this.name = name.trim(),
        this.motherName = motherName.trim(),
        this.fatherName = fatherName.trim() {
    if (this.id != null) Validator.validate(ValidatorType.Id, this.id!);
    Validator.validateAll([
      ValidationPair(ValidatorType.CPF, this.cpf),
      ValidationPair(ValidatorType.Name, this.name),
      ValidationPair(ValidatorType.OptionalName, this.motherName),
      ValidationPair(ValidatorType.OptionalName, this.fatherName),
      if (this.birthDate != null)
        ValidationPair(ValidatorType.BirthDate, this.birthDate!),
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
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cpf': cpf,
      'name': name,
      'birth_date': birthDate?.toString(),
      'locality': locality?.toMap(),
      'sex': sex.name,
      'mother_name': motherName,
      'father_name': fatherName,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      cpf: map['cpf'],
      name: map['name'],
      birthDate:
          map['birth_date'] != null ? DateTime.parse(map['birth_date']) : null,
      locality:
          map['locality'] != null ? Locality.fromMap(map['locality']) : null,
      sex: SexExtension.fromName(map['sex'] ?? Sex.NONE.name),
      motherName: map['mother_name'] ?? "",
      fatherName: map['father_name'] ?? "",
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
    return 'cpf: $cpf, name: $name';
  }
}

enum Sex { FEMALE, MALE, NONE }

extension SexExtension on Sex {
  static Sex fromName(String value) {
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

  String get toName {
    switch (this) {
      case Sex.FEMALE:
        return "FEMININO";
      case Sex.MALE:
        return "MASCULINO";
      case Sex.NONE:
      default:
        return "N??O SE APLICA";
    }
  }
}
