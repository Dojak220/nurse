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
    this.sex = Sex.none,
    String motherName = "",
    String fatherName = "",
  })  : name = name.trim(),
        motherName = motherName.trim(),
        fatherName = fatherName.trim() {
    if (id != null) Validator.validate(ValidatorType.id, id!);
    Validator.validateAll([
      ValidationPair(ValidatorType.cpf, cpf),
      ValidationPair(ValidatorType.name, this.name),
      ValidationPair(ValidatorType.optionalName, this.motherName),
      ValidationPair(ValidatorType.optionalName, this.fatherName),
      if (birthDate != null)
        ValidationPair(ValidatorType.birthDate, birthDate!),
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
      id: map['id'] as int?,
      cpf: map['cpf'] as String,
      name: map['name'] as String,
      birthDate: map['birth_date'] != null
          ? DateTime.parse(map['birth_date'] as String)
          : null,
      locality: map['locality'] != null
          ? Locality.fromMap(map['locality'] as Map<String, dynamic>)
          : null,
      sex: SexExtension.fromName(map['sex'] as String? ?? Sex.none.name),
      motherName: map['mother_name'] as String? ?? "",
      fatherName: map['father_name'] as String? ?? "",
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

enum Sex { female, male, none }

extension SexExtension on Sex {
  static Sex fromName(String value) {
    switch (value.toUpperCase()) {
      case "F":
      case "FEMALE":
      case "FEMININO":
        return Sex.female;
      case "M":
      case "MALE":
      case "MASCULINO":
        return Sex.male;
      case "N":
      case "NONE":
      case "NENHUM":
      default:
        return Sex.none;
    }
  }

  String get name {
    switch (this) {
      case Sex.female:
        return "FEMININO";
      case Sex.male:
        return "MASCULINO";
      case Sex.none:
      default:
        return "NÃO SE APLICA";
    }
  }
}
