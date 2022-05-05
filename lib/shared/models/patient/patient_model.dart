import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Patient implements GenericModel {
  @override
  final int id;
  final String cns;
  final PriorityCategory priorityCategory;
  final MaternalCondition maternalCondition;
  final Person person;

  Patient({
    required this.id,
    required this.cns,
    required this.priorityCategory,
    required this.maternalCondition,
    required this.person,
  }) {
    Validator.validate(ValidatorType.Id, this.id);
    Validator.validate(ValidatorType.CNS, this.cns);
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
  Map<String, Object> toMap() {
    return {
      'id': id,
      'cns': cns,
      'priority_category': priorityCategory.toMap(),
      'maternal_condition': maternalCondition.name,
      'person': person.toMap(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] ?? 0,
      cns: map['cns'] ?? "",
      priorityCategory: PriorityCategory.fromMap(map['priority_category']),
      maternalCondition: MaternalConditionExtension.fromString(
          map['maternal_condition'] ?? MaternalCondition.NENHUM.name),
      person: Person.fromMap(map['person']),
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
