import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';

class Application {
  final int id;
  final Patient patient;
  final DateTime applicationDate;
  final Applier applier;
  final VaccineBatch vaccineBatch;
  final VaccineDose vaccineDose;
  final Campaign campaign;
  final DateTime dueDate;

  Application({
    required this.id,
    required this.patient,
    required this.applicationDate,
    required this.applier,
    required this.vaccineBatch,
    required this.vaccineDose,
    required this.campaign,
    required this.dueDate,
  });

  Application copyWith({
    int? id,
    Patient? patient,
    DateTime? applicationDate,
    Applier? applier,
    VaccineBatch? vaccineBatch,
    VaccineDose? vaccineDose,
    Campaign? campaign,
    DateTime? dueDate,
  }) {
    return Application(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      applicationDate: applicationDate ?? this.applicationDate,
      applier: applier ?? this.applier,
      vaccineBatch: vaccineBatch ?? this.vaccineBatch,
      vaccineDose: vaccineDose ?? this.vaccineDose,
      campaign: campaign ?? this.campaign,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient': patient.toMap(),
      'applicationDate': applicationDate.millisecondsSinceEpoch,
      'applier': applier.toMap(),
      'vaccineBatch': vaccineBatch.toMap(),
      'vaccineDose': vaccineDose.name,
      'campaign': campaign.toMap(),
      'dueDate': dueDate.millisecondsSinceEpoch,
    };
  }

  factory Application.fromMap(Map<String, dynamic> map) {
    return Application(
      id: map['id']?.toInt() ?? 0,
      patient: Patient.fromMap(map['patient']),
      applicationDate:
          DateTime.fromMillisecondsSinceEpoch(map['applicationDate']),
      applier: Applier.fromMap(map['applier']),
      vaccineBatch: VaccineBatch.fromMap(map['vaccineBatch']),
      vaccineDose: VaccineDoseExtension.fromString(map['vaccineDose']),
      campaign: Campaign.fromMap(map['campaign']),
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
    );
  }

  @override
  String toString() {
    return 'Application(id: $id, patient: $patient, applicationDate: $applicationDate, applier: $applier, vaccineBatch: $vaccineBatch, vaccineDose: $vaccineDose, campaign: $campaign, dueDate: $dueDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Application &&
        other.id == id &&
        other.patient == patient &&
        other.applicationDate == applicationDate &&
        other.applier == applier &&
        other.vaccineBatch == vaccineBatch &&
        other.vaccineDose == vaccineDose &&
        other.campaign == campaign &&
        other.dueDate == dueDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        patient.hashCode ^
        applicationDate.hashCode ^
        applier.hashCode ^
        vaccineBatch.hashCode ^
        vaccineDose.hashCode ^
        campaign.hashCode ^
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
