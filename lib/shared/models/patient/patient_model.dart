import "package:flutter/foundation.dart";
import "package:nurse/shared/models/generic_model.dart";
import "package:nurse/shared/models/patient/person_model.dart";
import "package:nurse/shared/models/patient/priority_category_model.dart";
import "package:nurse/shared/utils/validator.dart";

@immutable
class Patient implements GenericModel {
  @override
  final int? id;
  final String cns;
  final PriorityCategory priorityCategory;
  final MaternalCondition maternalCondition;
  final Person person;

  Patient({
    this.id,
    required this.cns,
    required this.priorityCategory,
    required this.maternalCondition,
    required this.person,
  }) {
    if (id != null) Validator.validate(ValidatorType.id, id!);
    Validator.validate(ValidatorType.cns, cns);
  }

  Patient copyWith({
    int? id,
    String? cns,
    PriorityCategory? priorityCategory,
    MaternalCondition? maternalCondition,
    Person? person,
  }) {
    return Patient(
      id: id ?? this.id,
      cns: cns ?? this.cns,
      priorityCategory: priorityCategory ?? this.priorityCategory,
      maternalCondition: maternalCondition ?? this.maternalCondition,
      person: person ?? this.person,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "cns": cns,
      "priority_category": priorityCategory.id,
      "maternal_condition": maternalCondition.name,
      "person": person.id,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map["id"] as int?,
      cns: map["cns"] as String? ?? "",
      priorityCategory: PriorityCategory.fromMap(
        map["priority_category"] as Map<String, dynamic>,
      ),
      maternalCondition: MaternalConditionExtension.fromString(
        map["maternal_condition"] as String? ?? MaternalCondition.nenhum.name,
      ),
      person: Person.fromMap(map["person"] as Map<String, dynamic>),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Patient &&
        other.id == id &&
        other.cns == cns &&
        other.priorityCategory == priorityCategory &&
        other.maternalCondition == maternalCondition &&
        other.person == person;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cns.hashCode ^
        priorityCategory.hashCode ^
        maternalCondition.hashCode ^
        person.hashCode;
  }

  // coverage:ignore-start
  @override
  String toString() {
    return "Patient(id: $id, cns: $cns, priorityCategory: $priorityCategory, maternalCondition: $maternalCondition, person: $person)";
  }
  // coverage:ignore-end
}

enum MaternalCondition { nenhum, gestante, puerpera }

extension MaternalConditionExtension on MaternalCondition {
  static MaternalCondition fromString(String value) {
    switch (value.toUpperCase()) {
      case "GESTANTE":
        return MaternalCondition.gestante;
      case "PUERPERA":
        return MaternalCondition.puerpera;
      case "NENHUM":
        return MaternalCondition.nenhum;
    }

    return MaternalCondition.nenhum;
  }

  String get name {
    switch (this) {
      case MaternalCondition.gestante:
        return "GESTANTE";
      case MaternalCondition.puerpera:
        return "PUERPERA";
      case MaternalCondition.nenhum:
        return "NENHUM";
    }
  }
}
