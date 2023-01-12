import "package:flutter/foundation.dart";
import "package:nurse/shared/models/generic_model.dart";
import "package:nurse/shared/utils/validator.dart";

@immutable
class Vaccine implements GenericModel {
  @override
  final int? id;
  final String sipniCode;
  final String name;
  final String laboratory;

  Vaccine({
    this.id,
    required String sipniCode,
    required String name,
    required String laboratory,
  })  : sipniCode = sipniCode.trim(),
        name = name.trim(),
        laboratory = laboratory.trim() {
    _validateVaccine();
  }

  void _validateVaccine() {
    if (id != null) Validator.validate(ValidatorType.id, id!);
    Validator.validateAll([
      ValidationPair(ValidatorType.numericalString, sipniCode),
      ValidationPair(ValidatorType.name, name),
      ValidationPair(ValidatorType.name, laboratory),
    ]);
  }

  Vaccine copyWith({
    int? id,
    String? sipniCode,
    String? name,
    String? laboratory,
  }) {
    return Vaccine(
      id: id ?? this.id,
      sipniCode: sipniCode ?? this.sipniCode,
      name: name ?? this.name,
      laboratory: laboratory ?? this.laboratory,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "sipni_code": sipniCode,
      "name": name,
      "laboratory": laboratory,
    };
  }

  factory Vaccine.fromMap(Map<String, dynamic> map) {
    return Vaccine(
      id: map["id"] as int?,
      sipniCode: map["sipni_code"] as String? ?? "",
      name: map["name"] as String? ?? "",
      laboratory: map["laboratory"] as String? ?? "",
    );
  }

  // coverage:ignore-start
  @override
  String toString() {
    return "$sipniCode | $name";
  }
  // coverage:ignore-end

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vaccine &&
        other.id == id &&
        other.sipniCode == sipniCode &&
        other.name == name &&
        other.laboratory == laboratory;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sipniCode.hashCode ^
        name.hashCode ^
        laboratory.hashCode;
  }
}
