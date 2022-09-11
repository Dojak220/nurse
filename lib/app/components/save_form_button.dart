import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_theme.dart';

class SaveFormButton extends StatelessWidget {
  final void Function() onPressed;

  const SaveFormButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        child: ElevatedButton(
          style: AppTheme.stepButtonStyle,
          onPressed: onPressed,
          child: const Text("Salvar"),
        ),
      ),
    );
  }
}
