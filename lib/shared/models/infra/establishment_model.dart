import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Establishment implements GenericModel {
  @override
  final int id;
  final String cnes;
  final String name;
  final Locality locality;

  Establishment(
    this.id,
    this.cnes,
    this.name,
    this.locality,
  ) {
    /// TODO: Add validation below to Validator class.
    validateEstablishment();
  }

  void validateEstablishment() {
    Validator.validate(ValidatorType.Id, id);
    Validator.validate(ValidatorType.String, name);

    if (cnes.trim().length != 7) {
      throw Exception('Establishment cnes must be 7 characters long');
    }
    if (int.tryParse(cnes) == null) {
      throw Exception('Establishment cnes must be numeric');
    }
  }

  Map<String, Object> toMap() {
    return {
      'id': id,
      'cnes': cnes,
      'name': name,
      'locality': locality.toMap(),
    };
  }

  factory Establishment.fromMap(Map<String, dynamic> map) {
    return Establishment(
      map['id'] ?? 0,
      map['cnes'] ?? '',
      map['name'] ?? '',
      map['locality'] ?? Locality.fromMap(map['locality']),
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
      id ?? this.id,
      cnes ?? this.cnes,
      name ?? this.name,
      locality ?? this.locality,
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
