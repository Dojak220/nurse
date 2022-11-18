import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class VaccineBatch implements GenericModel {
  @override
  final int? id;
  final String number;
  final int quantity;
  final Vaccine vaccine;

  VaccineBatch({
    this.id,
    required String number,
    required this.quantity,
    required this.vaccine,
  }) : number = number.trim() {
    _validateVaccineBatch();
  }

  void _validateVaccineBatch() {
    if (id != null) Validator.validate(ValidatorType.id, id!);
    if (quantity <= 0) {
      throw Exception('Quantity must be greater than 0');
    }

    Validator.validate(ValidatorType.numericalString, number);
  }

  VaccineBatch copyWith({
    int? id,
    String? number,
    int? quantity,
    Vaccine? vaccine,
  }) {
    return VaccineBatch(
      id: id ?? this.id,
      number: number ?? this.number,
      quantity: quantity ?? this.quantity,
      vaccine: vaccine ?? this.vaccine,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'quantity': quantity,
      'vaccine': vaccine.id,
    };
  }

  factory VaccineBatch.fromMap(Map<String, dynamic> map) {
    return VaccineBatch(
      id: map['id'] as int?,
      number: map['number'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 0,
      vaccine: Vaccine.fromMap(map['vaccine'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() => 'Batch $number';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VaccineBatch &&
        other.id == id &&
        other.number == number &&
        other.quantity == quantity &&
        other.vaccine == vaccine;
  }

  @override
  int get hashCode =>
      id.hashCode ^ number.hashCode ^ quantity.hashCode ^ vaccine.hashCode;
}
