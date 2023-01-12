import "package:flutter/foundation.dart";
import "package:nurse/shared/models/generic_model.dart";
import "package:nurse/shared/models/infra/locality_model.dart";
import "package:nurse/shared/utils/validator.dart";

@immutable
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
    if (id != null) Validator.validate(ValidatorType.id, id!);
    Validator.validate(ValidatorType.name, name);

    if (cnes.trim().length != 7) {
      throw Exception("Establishment cnes must be 7 characters long");
    }
    if (int.tryParse(cnes) == null) {
      throw Exception("Establishment cnes must be numeric");
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "cnes": cnes,
      "name": name,
      "locality": locality.id,
    };
  }

  factory Establishment.fromMap(Map<String, dynamic> map) {
    return Establishment(
      id: map["id"] as int?,
      cnes: map["cnes"] as String? ?? "",
      name: map["name"] as String? ?? "",
      locality: Locality.fromMap(map["locality"] as Map<String, dynamic>),
    );
  }

  // coverage:ignore-start
  @override
  String toString() {
    return "$cnes - $name";
  }
  // coverage:ignore-end

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

  @override
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
