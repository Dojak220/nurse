import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Campaign implements GenericModel {
  @override
  final int? id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  Campaign({
    this.id,
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
        ValidationPair(ValidatorType.Name, this.title),
        ValidationPair(ValidatorType.Date, this.startDate),
        ValidationPair(ValidatorType.Date, this.endDate),
        ValidationPair(ValidatorType.Description, this.description),
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
      'id': id ?? 0,
      'title': title,
      'description': description,
      'start_date': startDate.toString(),
      'end_date': endDate.toString(),
    };
  }

  factory Campaign.fromMap(Map<String, dynamic> map) {
    return Campaign(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Campaign &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        startDate.hashCode ^
        endDate.hashCode;
  }

  @override
  String toString() {
    return 'CampaignModel(id: $id, title: $title, description: $description, startDate: $startDate, endDate: $endDate)';
  }
}
