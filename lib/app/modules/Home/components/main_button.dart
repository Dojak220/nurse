import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';

class VaccinationButton extends StatelessWidget {
  final String newPage;
  final void Function() onCallback;

  const VaccinationButton({
    Key? key,
    required this.newPage,
    required this.onCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context)
          .pushNamed(newPage)
          .whenComplete(() => onCallback()),
      style: AppTheme.mainButtonStyle(context),
      child: Text(
        "Vacinar",
        style: AppTheme.titleTextStyle.copyWith(color: AppColors.white),
      ),
    );
  }
}
