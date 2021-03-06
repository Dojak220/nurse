import 'package:nurse/shared/models/generic_model.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class Application implements GenericModel {
  @override
  final int? id;
  final Applier applier;
  final VaccineBatch vaccineBatch;
  final Patient patient;
  final Campaign campaign;
  final VaccineDose dose;
  final DateTime applicationDate;
  final DateTime dueDate;

  Application({
    this.id,
    required this.applier,
    required this.vaccineBatch,
    required this.patient,
    required this.campaign,
    required this.dose,
    required this.applicationDate,
    DateTime? dueDate,
  }) : dueDate = dueDate ?? applicationDate.add(Duration(days: 3 * 30)) {
    _validateApplication();
  }
  void _validateApplication() {
    if (this.id != null) Validator.validate(ValidatorType.Id, this.id!);
    Validator.validateAll([
      ValidationPair(ValidatorType.PastDate, this.applicationDate),
      ValidationPair(ValidatorType.Date, this.dueDate),
    ]);
  }

  Application copyWith({
    int? id,
    Applier? applier,
    VaccineBatch? vaccineBatch,
    Patient? patient,
    Campaign? campaign,
    VaccineDose? dose,
    DateTime? applicationDate,
    DateTime? dueDate,
  }) {
    return Application(
      id: id ?? this.id,
      applier: applier ?? this.applier,
      vaccineBatch: vaccineBatch ?? this.vaccineBatch,
      patient: patient ?? this.patient,
      campaign: campaign ?? this.campaign,
      dose: dose ?? this.dose,
      applicationDate: applicationDate ?? this.applicationDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'applier': applier.toMap(),
      'vaccine_batch': vaccineBatch.toMap(),
      'patient': patient.toMap(),
      'campaign': campaign.toMap(),
      'dose': dose.name,
      'application_date': applicationDate.toString(),
      'due_date': dueDate.toString(),
    };
  }

  factory Application.fromMap(Map<String, dynamic> map) {
    return Application(
      id: map['id'],
      applier: Applier.fromMap(map['applier']),
      vaccineBatch: VaccineBatch.fromMap(map['vaccine_batch']),
      patient: Patient.fromMap(map['patient']),
      campaign: Campaign.fromMap(map['campaign']),
      dose: VaccineDoseExtension.fromString(map['dose']),
      applicationDate: DateTime.parse(
        map['application_date'],
      ),
      dueDate: DateTime.parse(map['due_date']),
    );
  }

  @override
  String toString() {
    return 'Application(id: $id, applier: $applier, vaccineBatch: $vaccineBatch, patient: $patient, campaign: $campaign, dose: $dose, applicationDate: $applicationDate, dueDate: $dueDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Application &&
        other.id == id &&
        other.applier == applier &&
        other.vaccineBatch == vaccineBatch &&
        other.patient == patient &&
        other.campaign == campaign &&
        other.dose == dose &&
        other.applicationDate == applicationDate &&
        other.dueDate == dueDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        applier.hashCode ^
        vaccineBatch.hashCode ^
        patient.hashCode ^
        campaign.hashCode ^
        dose.hashCode ^
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

  String get name {
    switch (this) {
      case VaccineDose.D1:
        return "D1";
      case VaccineDose.D2:
        return "D2";
      case VaccineDose.DA:
        return "DA";
      case VaccineDose.REF:
        return "REF";
      default:
        throw Exception("Invalid VaccineDose");
    }
  }
}
