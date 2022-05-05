import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class VaccineBatch implements GenericModel {
  @override
  final int id;
  final String number;
  final int quantity;

  VaccineBatch({
    required this.id,
    required String number,
    required this.quantity,
  }) : this.number = number.trim() {
    _validateVaccineBatch();
  }

  void _validateVaccineBatch() {
    if (quantity <= 0) {
      throw Exception('Quantity must be greater than 0');
    }

    Validator.validateAll([
      ValidationPair(ValidatorType.Id, this.id),
      ValidationPair(ValidatorType.NumericalString, this.number),
    ]);
  }

  VaccineBatch copyWith({
    int? id,
    String? number,
    int? quantity,
  }) {
    return VaccineBatch(
      id: id ?? this.id,
      number: number ?? this.number,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, Object> toMap() {
    return {
      'id': id,
      'number': number,
      'quantity': quantity,
    };
  }

  factory VaccineBatch.fromMap(Map<String, dynamic> map) {
    return VaccineBatch(
      id: map['id'] ?? 0,
      number: map['number'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  @override
  String toString() =>
      'VaccineBatch(id: $id, number: $number, quantity: $quantity)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VaccineBatch &&
        other.id == id &&
        other.number == number &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => id.hashCode ^ number.hashCode ^ quantity.hashCode;
}
