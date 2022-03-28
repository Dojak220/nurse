import 'package:nurse/shared/models/generic_model.dart';

class Campaign implements GenericModel {
  @override
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  Campaign({
    required this.id,
    DateTime? endDate,
    String? description,
    required this.title,
    required this.startDate,
  })  : this.description = description ?? "Campanha $title",
        this.endDate = endDate ?? startDate.add(Duration(days: 365));

  @override
  Map<String, Object> toMap() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
    };
  }

  factory Campaign.fromMap(Map<String, dynamic> map) {
    return Campaign(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
    );
  }

  @override
  String toString() {
    return 'CampaignModel(id: $id, title: $title, description: $description, startDate: $startDate, endDate: $endDate)';
  }
}
