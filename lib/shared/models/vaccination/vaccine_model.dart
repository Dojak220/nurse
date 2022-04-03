import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';

class Vaccine {
  final String sipniCode;
  final String name;
  final String laboratory;
  final VaccineBatch vaccineBatch;

  Vaccine(
    this.sipniCode,
    this.name,
    this.laboratory,
    this.vaccineBatch,
  );

  Vaccine copyWith({
    String? sipniCode,
    String? name,
    String? laboratory,
    VaccineBatch? vaccineBatch,
  }) {
    return Vaccine(
      sipniCode ?? this.sipniCode,
      name ?? this.name,
      laboratory ?? this.laboratory,
      vaccineBatch ?? this.vaccineBatch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sipniCode': sipniCode,
      'name': name,
      'laboratory': laboratory,
      'vaccineBatch': vaccineBatch.toMap(),
    };
  }

  factory Vaccine.fromMap(Map<String, dynamic> map) {
    return Vaccine(
      map['sipniCode'] ?? '',
      map['name'] ?? '',
      map['laboratory'] ?? '',
      VaccineBatch.fromMap(map['vaccineBatch']),
    );
  }

  @override
  String toString() {
    return 'Vaccine(sipniCode: $sipniCode, name: $name, laboratory: $laboratory, vaccineBatch: $vaccineBatch)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vaccine &&
        other.sipniCode == sipniCode &&
        other.name == name &&
        other.laboratory == laboratory &&
        other.vaccineBatch == vaccineBatch;
  }

  @override
  int get hashCode {
    return sipniCode.hashCode ^
        name.hashCode ^
        laboratory.hashCode ^
        vaccineBatch.hashCode;
  }
}
