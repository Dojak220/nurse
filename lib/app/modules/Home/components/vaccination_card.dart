import "package:flutter/material.dart";
import "package:nurse/app/components/custom_card.dart";
import "package:nurse/shared/models/patient/patient_model.dart";

class VaccinationCard extends StatelessWidget {
  const VaccinationCard({
    Key? key,
    required this.cns,
    required this.name,
    required this.vaccine,
    required this.group,
    required this.pregnant,
    required this.onEditPressed,
  }) : super(key: key);

  final String cns;
  final String name;
  final String vaccine;
  final String group;
  final String pregnant;
  final void Function() onEditPressed;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: name,
      upperTitle: cns,
      startInfo: vaccine,
      centerInfo: group,
      endInfo: pregnant.toUpperCase() != MaternalCondition.nenhum.name
          ? pregnant
          : "",
      onEditPressed: onEditPressed,
    );
  }
}
