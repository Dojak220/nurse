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
  }) : dueDate = dueDate ?? applicationDate.add(const Duration(days: 3 * 30)) {
    _validateApplication();
  }
  void _validateApplication() {
    if (id != null) Validator.validate(ValidatorType.id, id!);
    Validator.validateAll([
      ValidationPair(ValidatorType.pastDate, applicationDate),
      ValidationPair(ValidatorType.date, dueDate),
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

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'applier': applier.id,
      'vaccine_batch': vaccineBatch.id,
      'patient': patient.id,
      'campaign': campaign.id,
      'dose': dose.name,
      'application_date': applicationDate.toString(),
      'due_date': dueDate.toString(),
    };
  }

  factory Application.fromMap(Map<String, dynamic> map) {
    return Application(
      id: map['id'] as int?,
      applier: Applier.fromMap(map['applier'] as Map<String, dynamic>),
      vaccineBatch:
          VaccineBatch.fromMap(map['vaccine_batch'] as Map<String, dynamic>),
      patient: Patient.fromMap(map['patient'] as Map<String, dynamic>),
      campaign: Campaign.fromMap(map['campaign'] as Map<String, dynamic>),
      dose: VaccineDoseExtension.fromString(map['dose'] as String),
      applicationDate: DateTime.parse(
        map['application_date'] as String,
      ),
      dueDate: map['due_date'] != null
          ? DateTime.parse(map['due_date'] as String)
          : null,
    );
  }

  // coverage:ignore-start
  @override
  String toString() {
    return 'Application(id: $id, applier: $applier, vaccineBatch: $vaccineBatch, patient: $patient, campaign: $campaign, dose: $dose, applicationDate: $applicationDate, dueDate: $dueDate)';
  }
  // coverage:ignore-end

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

enum VaccineDose { d1, d2, da, ref }

extension VaccineDoseExtension on VaccineDose {
  static VaccineDose fromString(String value) {
    switch (value.toUpperCase()) {
      case "D1":
        return VaccineDose.d1;
      case "D2":
        return VaccineDose.d2;
      case "DA":
        return VaccineDose.da;
      case "REF":
        return VaccineDose.ref;
      default:
        throw Exception("Invalid VaccineDose");
    }
  }

  String get name {
    switch (this) {
      case VaccineDose.d1:
        return "D1";
      case VaccineDose.d2:
        return "D2";
      case VaccineDose.da:
        return "DA";
      case VaccineDose.ref:
        return "REF";
      default:
        throw Exception("Invalid VaccineDose");
    }
  }
}
