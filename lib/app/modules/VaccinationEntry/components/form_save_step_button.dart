import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_step_button.dart';

class SaveFormButton extends StatelessWidget {
  const SaveFormButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepFormButton(
      active: true,
      onPressed: () {
        print("Save Data");
      },
      text: "Salvar",
    );
  }
}
