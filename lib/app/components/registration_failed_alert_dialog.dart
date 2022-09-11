import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/dialog_confirm_button.dart';

class RegistrationFailedAlertDialog extends StatelessWidget {
  final String entityName;

  const RegistrationFailedAlertDialog({
    Key? key,
    required this.entityName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.warning, size: 120.0),
          Text(
            'Falha ao cadastrar novo(a) $entityName!',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: const Text(
        'Cadastro já existia no banco de dados!',
        textAlign: TextAlign.center,
      ),
      actions: const [DialogConfirmButton(text: "Ok")],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );
  }
}
