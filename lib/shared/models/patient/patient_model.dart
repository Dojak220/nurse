import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/utils/validator.dart';

import '../generic_model.dart';

class Patient extends Person implements GenericModel {
  @override
  final int id;
  final String cns;
  final PriorityGroup priorityGroup;
  final MaternalCondition maternalCondition;

  Patient({
    required this.id,
    required this.cns,
    required this.priorityGroup,
    required this.maternalCondition,
    required Person person,
  }) : super(
          id: id,
          cpf: person.cpf,
          name: person.name,
          birthDate: person.birthDate,
          locality: person.locality,
          gender: person.gender,
          motherName: person.motherName,
          fatherName: person.fatherName,
        ) {
    Validator.validate(ValidatorType.Id, id);
    Validator.validate(ValidatorType.CNS, cns);
  }

  Patient copyWith({
    int? id,
    String? cns,
    PriorityGroup? priorityGroup,
    MaternalCondition? maternalCondition,
    Person? person,
  }) {
    return Patient(
      id: id ?? this.id,
      cns: cns ?? this.cns,
      priorityGroup: priorityGroup ?? this.priorityGroup,
      maternalCondition: maternalCondition ?? this.maternalCondition,
      person: Person(
        id: person?.id ?? this.id,
        cpf: person?.cpf ?? this.cpf,
        name: person?.name ?? this.name,
        birthDate: person?.birthDate ?? this.birthDate,
        locality: person?.locality ?? this.locality,
        gender: person?.gender ?? this.gender,
        motherName: person?.motherName ?? this.motherName,
        fatherName: person?.fatherName ?? this.fatherName,
      ),
    );
  }

  @override
  Map<String, Object> toMap() {
    return {
      'id': id,
      'cns': cns,
      'priorityGroup': priorityGroup.toMap(),
      'maternalCondition': maternalCondition.name,
      'person': super.toMap(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id']?.toInt() ?? 0,
      cns: map['cns']?.toInt() ?? 0,
      priorityGroup: PriorityGroup.fromMap(map['priorityGroup']),
      maternalCondition:
          MaternalConditionExtension.fromString(map['maternalCondition']),
      person: Person.fromMap(map['person']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Patient &&
        other.id == id &&
        other.cns == cns &&
        other.priorityGroup == priorityGroup &&
        other.maternalCondition == maternalCondition &&
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
        cns.hashCode ^
        priorityGroup.hashCode ^
        maternalCondition.hashCode ^
        cpf.hashCode ^
        name.hashCode ^
        birthDate.hashCode ^
        locality.hashCode ^
        gender.hashCode ^
        motherName.hashCode ^
        fatherName.hashCode;
  }
}

enum MaternalCondition { NENHUM, GESTANTE, PUERPERA }

extension MaternalConditionExtension on MaternalCondition {
  static MaternalCondition fromString(String value) {
    switch (value.toUpperCase()) {
      case "GESTANTE":
        return MaternalCondition.GESTANTE;
      case "PUERPERA":
        return MaternalCondition.PUERPERA;
      case "NENHUM":
      default:
        return MaternalCondition.NENHUM;
    }
  }
}
