import "package:flutter/material.dart";
import "package:nurse/app/theme/app_colors.dart";
import "package:nurse/app/theme/app_theme.dart";

class StepFormButton extends StatelessWidget {
  final bool active;
  final void Function() onPressed;
  final String text;

  const StepFormButton({
    Key? key,
    required this.active,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: active ? onPressed : null,
        style: active
            ? AppTheme.stepButtonStyle
            : AppTheme.stepButtonStyle.copyWith(
                backgroundColor: MaterialStateProperty.all(
                  AppColors.cinzaClaro,
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                    color: AppColors.cinzaClaro,
                  ),
                ),
              ),
        child: Text(text),
      ),
    );
  }
}
