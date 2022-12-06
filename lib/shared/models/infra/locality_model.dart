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
    if (id != null) Validator.validate(ValidatorType.id, id!);
    Validator.validateAll(
      [
        ValidationPair(ValidatorType.name, name),
        ValidationPair(ValidatorType.name, city),
        ValidationPair(ValidatorType.name, state),
        ValidationPair(ValidatorType.ibgeCode, ibgeCode),
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

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'state': state,
      'ibge_code': ibgeCode,
    };
  }

  factory Locality.fromMap(Map<String, dynamic> map) {
    return Locality(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      city: map['city'] as String? ?? '',
      state: map['state'] as String? ?? '',
      ibgeCode: map['ibge_code'] as String? ?? '',
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

  // coverage:ignore-start
  @override
  String toString() {
    return '$ibgeCode - $name, $city / $state';
  }
  // coverage:ignore-end
}
