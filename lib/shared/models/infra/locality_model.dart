import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Locality implements GenericModel {
  @override
  final int? id;
  final String name;
  final String city;
  final String state;
  final String ibgeCode;

  Locality({
    this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.ibgeCode,
  }) {
    _validateLocality();
  }

  void _validateLocality() {
    if (this.id != null) Validator.validate(ValidatorType.Id, this.id!);
    Validator.validateAll(
      [
        ValidationPair(ValidatorType.Name, this.name),
        ValidationPair(ValidatorType.Name, this.city),
        ValidationPair(ValidatorType.Name, this.state),
        ValidationPair(ValidatorType.IBGECode, this.ibgeCode),
      ],
    );
  }

  Locality copyWith({
    int? id,
    String? name,
    String? city,
    String? state,
    String? ibgeCode,
  }) {
    return Locality(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      state: state ?? this.state,
      ibgeCode: ibgeCode ?? this.ibgeCode,
    );
  }

  Map<String, Object> toMap() {
    return {
      'id': id ?? 0,
      'name': name,
      'city': city,
      'state': state,
      'ibge_code': ibgeCode,
    };
  }

  factory Locality.fromMap(Map<String, dynamic> map) {
    return Locality(
      id: map['id'],
      name: map['name'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      ibgeCode: map['ibge_code'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Locality &&
        other.id == id &&
        other.name == name &&
        other.city == city &&
        other.state == state &&
        other.ibgeCode == ibgeCode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        city.hashCode ^
        state.hashCode ^
        ibgeCode.hashCode;
  }

  @override
  String toString() {
    return 'Locality(id: $id, name: $name, city: $city, state: $state, ibgeCode: $ibgeCode)';
  }
}
