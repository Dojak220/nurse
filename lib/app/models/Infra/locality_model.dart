import 'package:nurse/app/models/generic_model.dart';

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
  );

  Map<String, dynamic> toMap() {
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
      map['id']?.toInt() ?? 0,
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
}
