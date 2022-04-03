import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Campaign implements GenericModel {
  @override
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  Campaign({
    required this.id,
    required String title,
    required this.startDate,
    DateTime? endDate,
    String description = "",
  })  : this.title = title.trim(),
        this.description =
            description.trim().isEmpty ? "Campanha $title" : description,
        this.endDate = endDate ?? startDate.add(Duration(days: 365)) {
    _validateCampaign();
  }

  void _validateCampaign() {
    if (endDate.isBefore(startDate)) {
      throw Exception('End date must be after start date');
    }

    Validator.validateAll(
      [
        ValidationPair(ValidatorType.Id, this.id),
        ValidationPair(ValidatorType.Name, this.title),
        ValidationPair(ValidatorType.Description, this.description),
        ValidationPair(ValidatorType.Date, this.startDate),
        ValidationPair(ValidatorType.Date, this.endDate),
      ],
    );
  }

  Campaign copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Campaign(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

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
