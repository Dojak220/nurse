import 'package:flutter/material.dart';
import 'package:nurse/shared/models/patient/person_model.dart';

class SexIcon extends Icon {
  final Sex? sex;
  const SexIcon(this.sex, {Key? key})
      : super(
          (sex == null || sex == Sex.none)
              ? Icons.question_mark_rounded
              : sex == Sex.female
                  ? Icons.female_rounded
                  : Icons.male_rounded,
          key: key,
        );
}
