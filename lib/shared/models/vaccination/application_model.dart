import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Application implements GenericModel {
  @override
  final int id;
  final Applier applier;
  final Patient patient;
  final Campaign campaign;
  final VaccineBatch vaccineBatch;
  final VaccineDose vaccineDose;
  final DateTime applicationDate;
  final DateTime dueDate;

  Application({
    required this.id,
    required this.applier,
    required this.patient,
    required this.campaign,
    required this.vaccineBatch,
    required this.vaccineDose,
    required this.applicationDate,
    DateTime? dueDate,
  }) : dueDate = dueDate ?? applicationDate.add(Duration(days: 3 * 30)) {
    _validateApplication();
  }
  void _validateApplication() {
    Validator.validateAll([
      ValidationPair(ValidatorType.Id, this.id),
      ValidationPair(ValidatorType.PastDate, this.applicationDate),
      ValidationPair(ValidatorType.Date, this.dueDate),
    ]);
  }

  Application copyWith({
    int? id,
    Applier? applier,
    Patient? patient,
    Campaign? campaign,
    VaccineBatch? vaccineBatch,
    VaccineDose? vaccineDose,
    DateTime? applicationDate,
    DateTime? dueDate,
  }) {
    return Application(
      id: id ?? this.id,
      applier: applier ?? this.applier,
      patient: patient ?? this.patient,
      campaign: campaign ?? this.campaign,
      vaccineBatch: vaccineBatch ?? this.vaccineBatch,
      vaccineDose: vaccineDose ?? this.vaccineDose,
      applicationDate: applicationDate ?? this.applicationDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, Object> toMap() {
    return {
      'id': id,
      'applier': applier.toMap(),
      'patient': patient.toMap(),
      'campaign': campaign.toMap(),
      'vaccineBatch': vaccineBatch.toMap(),
      'vaccineDose': vaccineDose.name,
      'applicationDate': applicationDate.millisecondsSinceEpoch,
      'dueDate': dueDate.millisecondsSinceEpoch,
    };
  }

  factory Application.fromMap(Map<String, dynamic> map) {
    return Application(
      id: map['id']?.toInt() ?? 0,
      applier: Applier.fromMap(map['applier']),
      patient: Patient.fromMap(map['patient']),
      campaign: Campaign.fromMap(map['campaign']),
      vaccineBatch: VaccineBatch.fromMap(map['vaccineBatch']),
      vaccineDose: VaccineDoseExtension.fromString(map['vaccineDose']),
      applicationDate:
          DateTime.fromMillisecondsSinceEpoch(map['applicationDate']),
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
    );
  }

  @override
  String toString() {
    return 'Application(id: $id, applier: $applier, patient: $patient, campaign: $campaign, vaccineBatch: $vaccineBatch, vaccineDose: $vaccineDose, applicationDate: $applicationDate, dueDate: $dueDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Application &&
        other.id == id &&
        other.applier == applier &&
        other.patient == patient &&
        other.campaign == campaign &&
        other.vaccineBatch == vaccineBatch &&
        other.vaccineDose == vaccineDose &&
        other.applicationDate == applicationDate &&
        other.dueDate == dueDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        applier.hashCode ^
        patient.hashCode ^
        campaign.hashCode ^
        vaccineBatch.hashCode ^
        vaccineDose.hashCode ^
        applicationDate.hashCode ^
        dueDate.hashCode;
  }
}

enum VaccineDose { D1, D2, DA, REF }

extension VaccineDoseExtension on VaccineDose {
  static VaccineDose fromString(String value) {
    switch (value.toUpperCase()) {
      case "D1":
        return VaccineDose.D1;
      case "D2":
        return VaccineDose.D2;
      case "DA":
        return VaccineDose.DA;
      case "REF":
        return VaccineDose.REF;
      default:
        throw Exception("Invalid VaccineDose");
    }
  }
}
