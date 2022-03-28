import 'package:nurse/shared/models/generic_model.dart';

class PriorityGroup implements GenericModel {
  @override
  final int id;
  final String groupCode;
  final String name;
  final String description;

  PriorityGroup({
    String name = "",
    required this.id,
    required this.groupCode,
    this.description = "",
  }) : this.name = name != "" ? name : groupCode;
}
