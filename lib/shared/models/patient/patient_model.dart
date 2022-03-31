import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/utils/validator.dart';

import '../generic_model.dart';

class Patient implements GenericModel {
  @override
  final int id;
  final String cns;
  final PriorityGroup priorityGroup;
  final MaternalCondition maternalCondition;
  final Person person;

  Patient({
    required this.id,
    required this.cns,
    required this.priorityGroup,
    required this.maternalCondition,
    required this.person,
  }) {
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
      person: person ?? this.person,
    );
  }

  @override
  Map<String, Object> toMap() {
    return {
      'id': id,
      'cns': cns,
      'priorityGroup': priorityGroup.toMap(),
      'maternalCondition': maternalCondition.name,
      'person': person.toMap(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id']?.toInt() ?? 0,
      cns: map['cns'] ?? "",
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
        other.person == person;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cns.hashCode ^
        priorityGroup.hashCode ^
        maternalCondition.hashCode ^
        person.hashCode;
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
