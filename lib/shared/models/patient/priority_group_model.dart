import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class PriorityGroup implements GenericModel {
  @override
  final int id;
  final String groupCode;
  final String name;
  final String description;

  PriorityGroup({
    required this.id,
    required String groupCode,
    String name = "",
    String description = "",
  })  : this.groupCode = groupCode.trim(),
        this.name = name.isEmpty ? groupCode : name.trim(),
        this.description = description.trim() {
    _validatePriorityGroup();
  }

  void _validatePriorityGroup() {
    Validator.validateAll(
      [
        ValidationPair(ValidatorType.Id, this.id),
        ValidationPair(ValidatorType.Name, this.groupCode),
        ValidationPair(ValidatorType.Name, this.name),
        ValidationPair(ValidatorType.Description, this.description),
      ],
    );
  }

  @override
  Map<String, Object> toMap() {
    return {
      'id': id,
      'groupCode': groupCode,
      'name': name,
      'description': description,
    };
  }

  PriorityGroup copyWith({
    int? id,
    String? groupCode,
    String? name,
    String? description,
  }) {
    return PriorityGroup(
      id: id ?? this.id,
      groupCode: groupCode ?? this.groupCode,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  factory PriorityGroup.fromMap(Map<String, dynamic> map) {
    return PriorityGroup(
      id: map['id']?.toInt() ?? 0,
      groupCode: map['groupCode'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PriorityGroup &&
        other.id == id &&
        other.groupCode == groupCode &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        groupCode.hashCode ^
        name.hashCode ^
        description.hashCode;
  }
}
