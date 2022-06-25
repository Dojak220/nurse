import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_theme.dart';

class DialogConfirmButton extends StatelessWidget {
  const DialogConfirmButton({
    Key? key,
    this.text = "Sim",
    this.onPressed,
  }) : super(key: key);

  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext ctx) {
    return ElevatedButton(
      onPressed: onPressed ?? () => Navigator.pop(ctx),
      style: AppTheme.dialogButtonStyle,
      child: Text(text),
    );
  }
}
