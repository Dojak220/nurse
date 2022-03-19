import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';

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
    if (cnes.trim().length != 7) {
      throw Exception('Establishment cnes must be 7 characters long');
    }
    if (int.tryParse(cnes) == null) {
      throw Exception('Establishment cnes must be numeric');
    }
    if (name.trim().isEmpty) {
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

  Establishment copyWith({
    int? id,
    String? cnes,
    String? name,
    Locality? locality,
  }) {
    return Establishment(
      id: id ?? this.id,
      cnes: cnes ?? this.cnes,
      name: name ?? this.name,
      locality: locality ?? this.locality,
    );
  }
}
