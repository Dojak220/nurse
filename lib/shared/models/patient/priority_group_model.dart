import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/utils/validator.dart';

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
  })  : this.code = code.trim(),
        this.name = name.isEmpty ? code : name.trim(),
        this.description = description.trim() {
    _validatePriorityGroup();
  }

  void _validatePriorityGroup() {
    if (this.id != null) Validator.validate(ValidatorType.Id, this.id!);
    Validator.validateAll(
      [
        ValidationPair(ValidatorType.Name, this.code),
        ValidationPair(ValidatorType.Name, this.name),
        ValidationPair(ValidatorType.Description, this.description),
      ],
    );
  }

  @override
  Map<String, Object> toMap() {
    return {
      'id': id ?? 0,
      'code': code,
      'name': name,
      'description': description,
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
      id: map['id'],
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
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

  @override
  String toString() {
    return 'PriorityGroup(id: $id, code: $code, name: $name, description: $description)';
  }
}
