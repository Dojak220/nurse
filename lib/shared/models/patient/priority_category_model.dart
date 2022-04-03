import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class PriorityCategory {
  final int id;
  final PriorityGroup priorityGroup;
  final String categoryCode;
  final String name;
  final String description;

  PriorityCategory({
    String name = "",
    required this.id,
    required this.priorityGroup,
    required String categoryCode,
    String description = "",
  })  : this.name = name.isEmpty ? categoryCode : name,
        this.categoryCode = categoryCode.trim(),
        this.description = description.trim() {
    _validatePriorityCategory();
  }

  void _validatePriorityCategory() {
    Validator.validateAll(
      [
        ValidationPair(ValidatorType.Id, id),
        ValidationPair(ValidatorType.Name, categoryCode),
        ValidationPair(ValidatorType.Name, name),
        ValidationPair(ValidatorType.Description, description),
      ],
    );
  }

  PriorityCategory copyWith({
    int? id,
    PriorityGroup? priorityGroup,
    String? categoryCode,
    String? name,
    String? description,
  }) {
    return PriorityCategory(
      id: id ?? this.id,
      priorityGroup: priorityGroup ?? this.priorityGroup,
      categoryCode: categoryCode ?? this.categoryCode,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'priorityGroup': priorityGroup.toMap(),
      'categoryCode': categoryCode,
      'name': name,
      'description': description,
    };
  }

  factory PriorityCategory.fromMap(Map<String, dynamic> map) {
    return PriorityCategory(
      id: map['id']?.toInt() ?? 0,
      priorityGroup: PriorityGroup.fromMap(map['priorityGroup']),
      categoryCode: map['categoryCode'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PriorityCategory &&
        other.id == id &&
        other.priorityGroup == priorityGroup &&
        other.categoryCode == categoryCode &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        priorityGroup.hashCode ^
        categoryCode.hashCode ^
        name.hashCode ^
        description.hashCode;
  }

  @override
  String toString() {
    return 'PriorityCategory(id: $id, priorityGroup: $priorityGroup, categoryCode: $categoryCode, name: $name, description: $description)';
  }
}
