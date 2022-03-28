import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Locality implements GenericModel {
  @override
  final int id;
  final String name;
  final String city;
  final String state;
  final String ibgeCode;

  Locality(
    this.id,
    this.name,
    this.city,
    this.state,
    this.ibgeCode,
  ) {
    validateLocality();
  }

  void validateLocality() {
    Validator.validateAll(
      [
        ValidationPair(ValidatorType.Id, id),
        ValidationPair(ValidatorType.String, name),
        ValidationPair(ValidatorType.String, city),
        ValidationPair(ValidatorType.String, state),
        ValidationPair(ValidatorType.String, ibgeCode),
      ],
    );
  }

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'state': state,
      'ibgeCode': ibgeCode,
    };
  }

  factory Locality.fromMap(Map<String, dynamic> map) {
    return Locality(
      map['id'] ?? 0,
      map['name'] ?? '',
      map['city'] ?? '',
      map['state'] ?? '',
      map['ibgeCode'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Locality(id: $id, name: $name, city: $city, state: $state, ibgeCode: $ibgeCode)';
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

  Locality copyWith({
    int? id,
    String? name,
    String? city,
    String? state,
    String? ibgeCode,
  }) {
    return Locality(
      id ?? this.id,
      name ?? this.name,
      city ?? this.city,
      state ?? this.state,
      ibgeCode ?? this.ibgeCode,
    );
  }
}
