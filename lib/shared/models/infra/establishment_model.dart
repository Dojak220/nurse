import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Establishment implements GenericModel {
  @override
  final int? id;
  final String cnes;
  final String name;
  final Locality locality;

  Establishment({
    this.id,
    required this.cnes,
    required this.name,
    required this.locality,
  }) {
    /// TODO: Add validation below to Validator class.
    _validateEstablishment();
  }

  void _validateEstablishment() {
    if (this.id != null) Validator.validate(ValidatorType.Id, this.id!);
    Validator.validate(ValidatorType.Name, this.name);

    if (cnes.trim().length != 7) {
      throw Exception('Establishment cnes must be 7 characters long');
    }
    if (int.tryParse(cnes) == null) {
      throw Exception('Establishment cnes must be numeric');
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
      id: map['id'],
      cnes: map['cnes'] ?? '',
      name: map['name'] ?? '',
      locality: Locality.fromMap(map['locality']),
    );
  }

  @override
  String toString() {
    return '$cnes - $name';
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

  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Establishment &&
        other.id == id &&
        other.cnes == cnes &&
        other.name == name &&
        other.locality == locality;
  }

  @override
  int get hashCode {
    return id.hashCode ^ cnes.hashCode ^ name.hashCode ^ locality.hashCode;
  }
}
