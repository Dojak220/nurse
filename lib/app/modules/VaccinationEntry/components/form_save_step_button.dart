import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_step_button.dart';

class SaveFormButton extends StatelessWidget {
  final void Function() onPressed;

  const SaveFormButton(this.onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepFormButton(
      active: true,
      onPressed: onPressed,
      text: "Salvar",
    );
  }
}
