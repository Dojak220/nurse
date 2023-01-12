import "package:flutter/foundation.dart";
import "package:intl/intl.dart";
import "package:nurse/shared/models/generic_model.dart";
import "package:nurse/shared/utils/validator.dart";

@immutable
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
  })  : title = title.trim(),
        description = description.trim().isEmpty ? title : description,
        endDate = endDate ?? startDate.add(const Duration(days: 365)) {
    _validateCampaign();
  }

  void _validateCampaign() {
    if (id != null) Validator.validate(ValidatorType.id, id!);

    if (endDate.isBefore(startDate)) {
      throw Exception("End date must be after start date");
    }

    Validator.validateAll(
      [
        ValidationPair(ValidatorType.name, title),
        ValidationPair(ValidatorType.date, startDate),
        ValidationPair(ValidatorType.date, endDate),
        ValidationPair(ValidatorType.description, description),
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
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "start_date": DateFormat("yyyy-MM-dd").format(startDate),
      "end_date": DateFormat("yyyy-MM-dd").format(endDate),
    };
  }

  factory Campaign.fromMap(Map<String, dynamic> map) {
    return Campaign(
      id: map["id"] as int?,
      title: map["title"] as String? ?? "",
      description: map["description"] as String? ?? "",
      startDate: DateTime.parse(map["start_date"] as String),
      endDate: map["end_date"] != null
          ? DateTime.parse(map["end_date"] as String)
          : null,
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

  // coverage:ignore-start
  @override
  String toString() {
    return title;
  }
  // coverage:ignore-end
}
