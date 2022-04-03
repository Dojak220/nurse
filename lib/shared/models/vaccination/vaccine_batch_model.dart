import 'package:nurse/shared/utils/validator.dart';

class VaccineBatch {
  final int id;
  final String batchNo;
  final int quantity;

  VaccineBatch({
    required this.id,
    required String batchNo,
    required this.quantity,
  }) : this.batchNo = batchNo.trim() {
    _validateVaccineBatch();
  }

  void _validateVaccineBatch() {
    if (quantity <= 0) {
      throw Exception('Quantity must be greater than 0');
    }

    Validator.validateAll([
      ValidationPair(ValidatorType.Id, this.id),
      ValidationPair(ValidatorType.NumericalString, this.batchNo),
    ]);
  }

  VaccineBatch copyWith({
    int? id,
    String? batchNo,
    int? quantity,
  }) {
    return VaccineBatch(
      id: id ?? this.id,
      batchNo: batchNo ?? this.batchNo,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'batchNo': batchNo,
      'quantity': quantity,
    };
  }

  factory VaccineBatch.fromMap(Map<String, dynamic> map) {
    return VaccineBatch(
      id: map['id']?.toInt() ?? 0,
      batchNo: map['batchNo'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  @override
  String toString() =>
      'VaccineBatch(id: $id, batchNo: $batchNo, quantity: $quantity)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VaccineBatch &&
        other.id == id &&
        other.batchNo == batchNo &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => id.hashCode ^ batchNo.hashCode ^ quantity.hashCode;
}
