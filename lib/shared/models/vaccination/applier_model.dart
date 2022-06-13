import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Applier implements GenericModel {
  @override
  final int? id;
  final String cns;
  final Person person;
  final Establishment establishment;

  Applier({
    this.id,
    required this.cns,
    required this.person,
    required this.establishment,
  }) {
    if (this.id != null) Validator.validate(ValidatorType.Id, this.id!);
    Validator.validate(ValidatorType.CNS, this.cns);
  }

  Applier copyWith({
    int? id,
    String? cns,
    Person? person,
    Establishment? establishment,
  }) {
    return Applier(
      id: id ?? this.id,
      cns: cns ?? this.cns,
      person: person ?? this.person,
      establishment: establishment ?? this.establishment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cns': cns,
      'person': person.toMap(),
      'establishment': establishment.toMap(),
    };
  }

  factory Applier.fromMap(Map<String, dynamic> map) {
    return Applier(
      id: map['id'],
      cns: map['cns'] ?? '',
      person: Person.fromMap(map['person']),
      establishment: Establishment.fromMap(map['establishment']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Applier &&
        other.id == id &&
        other.cns == cns &&
        other.person == person &&
        other.establishment == establishment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cns.hashCode ^
        person.hashCode ^
        establishment.hashCode;
  }

  @override
  String toString() {
    return '${cns.replaceRange(3, 12, "...")} - ${person.name}';
  }
}
