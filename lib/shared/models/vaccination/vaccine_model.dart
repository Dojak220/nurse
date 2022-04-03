import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Vaccine implements GenericModel {
  @override
  final int id;
  final String sipniCode;
  final String name;
  final String laboratory;
  final VaccineBatch vaccineBatch;

  Vaccine({
    required this.id,
    required String sipniCode,
    required String name,
    required String laboratory,
    required this.vaccineBatch,
  })  : this.sipniCode = sipniCode.trim(),
        this.name = name.trim(),
        this.laboratory = laboratory.trim() {
    _validateVaccine();
  }

  void _validateVaccine() {
    Validator.validateAll([
      ValidationPair(ValidatorType.Id, this.id),
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
    VaccineBatch? vaccineBatch,
  }) {
    return Vaccine(
      id: id ?? this.id,
      sipniCode: sipniCode ?? this.sipniCode,
      name: name ?? this.name,
      laboratory: laboratory ?? this.laboratory,
      vaccineBatch: vaccineBatch ?? this.vaccineBatch,
    );
  }

  Map<String, Object> toMap() {
    return {
      'id': id,
      'sipniCode': sipniCode,
      'name': name,
      'laboratory': laboratory,
      'vaccineBatch': vaccineBatch.toMap(),
    };
  }

  factory Vaccine.fromMap(Map<String, dynamic> map) {
    return Vaccine(
      id: map['id']?.toInt() ?? 0,
      sipniCode: map['sipniCode'] ?? '',
      name: map['name'] ?? '',
      laboratory: map['laboratory'] ?? '',
      vaccineBatch: VaccineBatch.fromMap(map['vaccineBatch']),
    );
  }

  @override
  String toString() {
    return 'Vaccine(id: $id, sipniCode: $sipniCode, name: $name, laboratory: $laboratory, vaccineBatch: $vaccineBatch)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vaccine &&
        other.id == id &&
        other.sipniCode == sipniCode &&
        other.name == name &&
        other.laboratory == laboratory &&
        other.vaccineBatch == vaccineBatch;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sipniCode.hashCode ^
        name.hashCode ^
        laboratory.hashCode ^
        vaccineBatch.hashCode;
  }
}
