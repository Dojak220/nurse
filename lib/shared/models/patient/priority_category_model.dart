import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class PriorityCategory implements GenericModel {
  @override
  final int? id;
  final PriorityGroup priorityGroup;
  final String code;
  final String name;
  final String description;

  PriorityCategory({
    this.id,
    required String code,
    required this.priorityGroup,
    String name = "",
    String description = "",
  })  : name = name.isEmpty ? code : name,
        code = code.trim(),
        description = description.trim() {
    _validatePriorityCategory();
  }

  void _validatePriorityCategory() {
    if (id != null) Validator.validate(ValidatorType.id, id!);
    Validator.validateAll(
      [
        ValidationPair(ValidatorType.name, code),
        ValidationPair(ValidatorType.name, name),
        ValidationPair(ValidatorType.description, description),
      ],
    );
  }

  PriorityCategory copyWith({
    int? id,
    PriorityGroup? priorityGroup,
    String? code,
    String? name,
    String? description,
  }) {
    return PriorityCategory(
      id: id ?? this.id,
      priorityGroup: priorityGroup ?? this.priorityGroup,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'priority_group': priorityGroup.toMap(),
      'code': code,
      'name': name,
      'description': description,
    };
  }

  factory PriorityCategory.fromMap(Map<String, dynamic> map) {
    return PriorityCategory(
      id: map['id'] as int?,
      priorityGroup:
          PriorityGroup.fromMap(map['priority_group'] as Map<String, dynamic>),
      code: map['code'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PriorityCategory &&
        other.id == id &&
        other.priorityGroup == priorityGroup &&
        other.code == code &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        priorityGroup.hashCode ^
        code.hashCode ^
        name.hashCode ^
        description.hashCode;
  }

  @override
  String toString() {
    return name.toUpperCase();
  }
}
