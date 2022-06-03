import 'package:flutter/material.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';

abstract class CustomFormField extends StatelessWidget {
  final Icon icon;
  final String hint;
  final String description;
  final InputBorder border;

  const CustomFormField({
    Key? key,
    required this.icon,
    required this.hint,
    required this.description,
    this.border = const OutlineInputBorder(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context);
}

class ApplicationFormModel {
  final String cnsPatient;
  final String batchNumber;
  final VaccineDose dose;
  final String cnsApplier;
  final DateTime date;
  final PriorityGroup group;
  final MaternalCondition maternalCondition;

  ApplicationFormModel(
    this.cnsPatient,
    this.batchNumber,
    this.dose,
    this.cnsApplier,
    this.date,
    this.group,
    this.maternalCondition,
  );
}

enum ApplicationLabels {
  cnsPatient,
  batchNumber,
  dose,
  cnsApplier,
  date,
  group,
  maternalCondition,
}

extension LabelNamesAndHints on ApplicationLabels {
  String get description {
    switch (this) {
      case ApplicationLabels.cnsPatient:
        return "CNS do(a) Paciente *";
      case ApplicationLabels.batchNumber:
        return "Lote *";
      case ApplicationLabels.dose:
        return "Dose *";
      case ApplicationLabels.cnsApplier:
        return "CNS do(a) Aplicador(a) *";
      case ApplicationLabels.date:
        return "Data de Aplicação *";
      case ApplicationLabels.group:
        return "Grupo Prioritário *";
      case ApplicationLabels.maternalCondition:
        return "Condição Maternal *";
      default:
        return "";
    }
  }

  String get hint {
    switch (this) {
      case ApplicationLabels.cnsPatient:
        return "Número do Cartão Nacional de Saúde do(a) Paciente";
      case ApplicationLabels.batchNumber:
        return "Número do Lote da Vacina";
      case ApplicationLabels.dose:
        return "Dose da Vacina";
      case ApplicationLabels.cnsApplier:
        return "Número do Cartão Nacional de Saúde do(a) Aplicador";
      case ApplicationLabels.date:
        return "Data da aplicação";
      case ApplicationLabels.group:
        return "Grupo Prioritário";
      case ApplicationLabels.maternalCondition:
        return "Condição Maternal";
      default:
        return "";
    }
  }
}
