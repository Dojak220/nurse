import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/utils/validator.dart';

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
  })  : this.sipniCode = sipniCode.trim(),
        this.name = name.trim(),
        this.laboratory = laboratory.trim() {
    _validateVaccine();
  }

  void _validateVaccine() {
    if (this.id != null) Validator.validate(ValidatorType.Id, this.id!);
    Validator.validateAll([
      ValidationPair(ValidatorType.NumericalString, this.sipniCode),
      ValidationPair(ValidatorType.Name, this.name),
      ValidationPair(ValidatorType.Name, this.laboratory),
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sipni_code': sipniCode,
      'name': name,
      'laboratory': laboratory,
    };
  }

  factory Vaccine.fromMap(Map<String, dynamic> map) {
    return Vaccine(
      id: map['id'],
      sipniCode: map['sipni_code'] ?? '',
      name: map['name'] ?? '',
      laboratory: map['laboratory'] ?? '',
    );
  }

  @override
  String toString() {
    return '$sipniCode | $name';
  }

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
