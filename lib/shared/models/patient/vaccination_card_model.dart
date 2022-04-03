import 'package:flutter/foundation.dart';

import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class VaccinationCard {
  final int id;
  final List<Application> applications;

  VaccinationCard({
    required this.id,
    required this.applications,
  }) {
    _validateVaccinationCard();
  }

  void _validateVaccinationCard() {
    if (applications.isEmpty) {
      throw Exception('Vaccination card must have at least one application');
    }

    Validator.validate(ValidatorType.Id, id);
  }

  VaccinationCard copyWith({
    int? id,
    List<Application>? applications,
  }) {
    return VaccinationCard(
      id: id ?? this.id,
      applications: applications ?? this.applications,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'applications': applications.map((x) => x.toMap()).toList(),
    };
  }

  factory VaccinationCard.fromMap(Map<String, dynamic> map) {
    return VaccinationCard(
      id: map['id']?.toInt() ?? 0,
      applications: List<Application>.from(
          map['applications']?.map((x) => Application.fromMap(x))),
    );
  }

  @override
  String toString() => 'VaccinationCard(id: $id, applications: $applications)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VaccinationCard &&
        other.id == id &&
        listEquals(other.applications, applications);
  }

  @override
  int get hashCode => id.hashCode ^ applications.hashCode;
}
