import 'package:nurse/app/models/infra/locality_model.dart';
import 'package:nurse/app/models/generic_model.dart';

class Establishment implements GenericModel {
  @override
  final int id;
  final String cnes;
  final String name;
  final Locality locality;

  Establishment({
    required this.id,
    required this.cnes,
    required this.name,
    required this.locality,
  }) {
    validateEstablishment();
  }
  void validateEstablishment() {
    if (id <= 0) {
      throw Exception('Establishment id must be greater than 0');
    }
    if (cnes.length != 7) {
      throw Exception('Establishment cnes must be 7 characters long');
    }
    if (name.isEmpty) {
      throw Exception('Establishment name must be filled');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cnes': cnes,
      'name': name,
      'locality': locality.toMap(),
    };
  }

  factory Establishment.fromMap(Map<String, dynamic> map) {
    return Establishment(
      id: map['id']?.toInt() ?? 0,
      cnes: map['cnes'] ?? '',
      name: map['name'] ?? '',
      locality: Locality.fromMap(map['locality']),
    );
  }

  @override
  String toString() {
    return 'Establishment(id: $id, cnes: $cnes, name: $name, locality: $locality)';
  }
}
