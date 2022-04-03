import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Applier {
  final String cns;
  final Person person;
  final Establishment establishment;

  Applier({
    required this.cns,
    required this.person,
    required this.establishment,
  }) {
    Validator.validateAll([
      ValidationPair(ValidatorType.Id, this.id),
      ValidationPair(ValidatorType.CNS, this.cns),
    ]);
  }

  Applier copyWith({
    String? cns,
    Person? person,
    Establishment? establishment,
  }) {
    return Applier(
      cns: cns ?? this.cns,
      person: person ?? this.person,
      establishment: establishment ?? this.establishment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cns': cns,
      'person': person.toMap(),
      'establishment': establishment.toMap(),
    };
  }

  factory Applier.fromMap(Map<String, dynamic> map) {
    return Applier(
      cns: map['cns'] ?? '',
      person: Person.fromMap(map['person']),
      establishment: Establishment.fromMap(map['establishment']),
    );
  }

  @override
  String toString() =>
      'Applier(cns: $cns, person: $person, establishment: $establishment)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Applier &&
        other.cns == cns &&
        other.person == person &&
        other.establishment == establishment;
  }

  @override
  int get hashCode => cns.hashCode ^ person.hashCode ^ establishment.hashCode;
}
