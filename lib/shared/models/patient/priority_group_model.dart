import "package:flutter/foundation.dart";
import "package:nurse/shared/models/generic_model.dart";
import "package:nurse/shared/utils/validator.dart";

@immutable
class PriorityGroup implements GenericModel {
  @override
  final int? id;
  final String code;
  final String name;
  final String description;

  PriorityGroup({
    this.id,
    required String code,
    String name = "",
    String description = "",
  })  : code = code.trim(),
        name = name.isEmpty ? code : name.trim(),
        description = description.trim() {
    _validatePriorityGroup();
  }

  void _validatePriorityGroup() {
    if (id != null) Validator.validate(ValidatorType.id, id!);
    Validator.validateAll(
      [
        ValidationPair(ValidatorType.name, code),
        ValidationPair(ValidatorType.name, name),
        ValidationPair(ValidatorType.description, description),
      ],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "code": code,
      "name": name,
      "description": description,
    };
  }

  PriorityGroup copyWith({
    int? id,
    String? code,
    String? name,
    String? description,
  }) {
    return PriorityGroup(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  factory PriorityGroup.fromMap(Map<String, dynamic> map) {
    return PriorityGroup(
      id: map["id"] as int?,
      code: map["code"] as String? ?? "",
      name: map["name"] as String? ?? "",
      description: map["description"] as String? ?? "",
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PriorityGroup &&
        other.id == id &&
        other.code == code &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^ code.hashCode ^ name.hashCode ^ description.hashCode;
  }

  // coverage:ignore-start
  @override
  String toString() {
    return name;
  }
  // coverage:ignore-end
}
