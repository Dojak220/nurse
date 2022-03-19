import 'package:nurse/app/models/patient/priority_group_model.dart';

class PriorityCategory {
  final int id;
  final PriorityGroupModel priorityGroup;
  final String categoryCode;
  final String name;
  final String description;

  PriorityCategory({
    required this.id,
    required this.priorityGroup,
    required this.categoryCode,
    String name = "",
    this.description = "",
  }) : this.name = name != "" ? name : categoryCode;
}
