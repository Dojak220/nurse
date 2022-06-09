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

enum FormLabels {
  namePatient,
  cnsPatient,
  cnsApplier,
  cpfPatient,
  cpfApplier,
  batchNumber,
  dose,
  date,
  category,
  group,
  maternalCondition,
}

extension LabelNamesAndHints on FormLabels {
  String get description {
    switch (this) {
      case FormLabels.namePatient:
        return "Nome completo do(a) Paciente *";
      case FormLabels.cnsPatient:
        return "CNS do(a) Paciente *";
      case FormLabels.cnsApplier:
        return "CNS do(a) Aplicante *";
      case FormLabels.cpfPatient:
        return "CPF do(a) Paciente *";
      case FormLabels.cpfApplier:
        return "CPF do(a) Aplicante *";
      case FormLabels.batchNumber:
        return "Lote *";
      case FormLabels.dose:
        return "Dose *";
      case FormLabels.cnsApplier:
        return "CNS do(a) Aplicador(a) *";
      case FormLabels.date:
        return "Data de Aplicação *";
      case FormLabels.group:
        return "Grupo Prioritário *";
      case FormLabels.category:
        return "Categoria Prioritária *";
      case FormLabels.maternalCondition:
        return "Condição Maternal *";
      default:
        return "";
    }
  }

  String get hint {
    switch (this) {
      case FormLabels.cnsPatient:
        return "Número do Cartão Nacional de Saúde do(a) paciente";
      case FormLabels.batchNumber:
        return "Número do lote da vacina";
      case FormLabels.dose:
        return "Dose da vacina";
      case FormLabels.cnsApplier:
        return "Número do Cartão Nacional de Saúde do(a) aplicador(a)";
      case FormLabels.date:
        return "Data da aplicação da vacina";
      case FormLabels.group:
        return "Grupo do(a) paciente";
      case FormLabels.category:
        return "Categoria do(a) paciente";
      case FormLabels.maternalCondition:
        return "Condição Maternal do(a) paciente";
      default:
        return "";
    }
  }
}
