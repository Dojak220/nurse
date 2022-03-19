class PriorityGroupModel {
  final int id;
  final String groupCode;
  final String name;
  final String description;

  PriorityGroupModel({
    required this.id,
    required this.groupCode,
    String name = "",
    this.description = "",
  }) : this.name = name != "" ? name : groupCode;
}
