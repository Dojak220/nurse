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
  }) : this.number = number.trim() {
    _validateVaccineBatch();
  }

  void _validateVaccineBatch() {
    if (this.id != null) Validator.validate(ValidatorType.Id, this.id!);
    if (quantity <= 0) {
      throw Exception('Quantity must be greater than 0');
    }

    Validator.validate(ValidatorType.NumericalString, this.number);
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'quantity': quantity,
      'vaccine': vaccine.toMap(),
    };
  }

  factory VaccineBatch.fromMap(Map<String, dynamic> map) {
    return VaccineBatch(
      id: map['id'],
      number: map['number'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      vaccine: Vaccine.fromMap(map['vaccine']),
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
