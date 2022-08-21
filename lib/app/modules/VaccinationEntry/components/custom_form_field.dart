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
  applierCns,
  applierCpf,
  applierName,
  campaign,
  category,
  date,
  dose,
  establishmentCNES,
  establishmentLocalityName,
  establishmentName,
  group,
  maternalCondition,
  patientCns,
  patientCpf,
  patientName,
  sex,
  vaccineBatch,
  vaccineLaboratory,
  vaccine,
  vaccineSipniCode,
}

extension LabelNamesAndHints on FormLabels {
  String get description {
    switch (this) {
      case FormLabels.applierCns:
        return "CNS do(a) Aplicante *";
      case FormLabels.applierCpf:
        return "CPF do(a) Aplicante *";
      case FormLabels.applierName:
        return "Nome Completo do(a) Aplicante *";
      case FormLabels.campaign:
        return "Campanha *";
      case FormLabels.category:
        return "Categoria Prioritária *";
      case FormLabels.date:
        return "Data de Aplicação *";
      case FormLabels.dose:
        return "Dose *";
      case FormLabels.establishmentCNES:
        return "CNES do Estabelecimento *";
      case FormLabels.establishmentLocalityName:
        return "Localidade do Estabelecimento *";
      case FormLabels.establishmentName:
        return "Nome do Estabelecimento *";
      case FormLabels.group:
        return "Grupo Prioritário *";
      case FormLabels.maternalCondition:
        return "Condição Maternal *";
      case FormLabels.patientCns:
        return "CNS do(a) Paciente *";
      case FormLabels.patientCpf:
        return "CPF do(a) Paciente *";
      case FormLabels.patientName:
        return "Nome Completo do(a) Paciente *";
      case FormLabels.sex:
        return "Sexo do(a) Paciente";
      case FormLabels.vaccineBatch:
        return "Lote da Vacina*";
      case FormLabels.vaccineLaboratory:
        return "Laboratório *";
      case FormLabels.vaccine:
        return "Nome da Vacina *";
      case FormLabels.vaccineSipniCode:
        return "Código SIPNI *";
      default:
        return "";
    }
  }

  String get hint {
    switch (this) {
      case FormLabels.applierCns:
        return "Número do Cartão Nacional de Saúde do(a) aplicador(a)";
      case FormLabels.applierCpf:
        return "Número do Cadastro de Pessoas Físicas do(a) aplicador(a)";
      case FormLabels.applierName:
        return "Nome completo do(a) aplicante";
      case FormLabels.campaign:
        return "Campanha de vacinação";
      case FormLabels.category:
        return "Categoria do(a) paciente";
      case FormLabels.date:
        return "Data da aplicação da vacina";
      case FormLabels.dose:
        return "Dose da vacina";
      case FormLabels.establishmentCNES:
        return "CNES do estabelecimento";
      case FormLabels.establishmentName:
        return "Nome do estabelecimento";
      case FormLabels.group:
        return "Grupo do(a) paciente";
      case FormLabels.maternalCondition:
        return "Condição Maternal do(a) paciente";
      case FormLabels.patientCns:
        return "Número do Cartão Nacional de Saúde do(a) paciente";
      case FormLabels.patientCpf:
        return "Número do Cadastro de Pessoas Físicas do(a) paciente";
      case FormLabels.patientName:
        return "Nome completo do(a) paciente";
      case FormLabels.sex:
        return "Sexo do(a) paciente";
      case FormLabels.vaccineBatch:
        return "Número do lote da vacina";
      case FormLabels.vaccineLaboratory:
        return "Laboratório da vacina";
      case FormLabels.vaccine:
        return "Nome da vacina";
      case FormLabels.vaccineSipniCode:
        return "Código SIPNI da vacina";
      default:
        return "";
    }
  }
}
