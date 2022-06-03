import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_theme.dart';

class DialogCancelButton extends StatelessWidget {
  const DialogCancelButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final void Function()? onPressed;

  @override
  Widget build(BuildContext ctx) {
    return TextButton(
      onPressed: onPressed ?? () => Navigator.pop(ctx),
      style: AppTheme.dialogButtonStyle.copyWith(
        backgroundColor: MaterialStateProperty.all(null),
      ),
      child: const Text('Não'),
    );
  }
}
