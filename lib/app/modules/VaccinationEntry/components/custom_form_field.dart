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
