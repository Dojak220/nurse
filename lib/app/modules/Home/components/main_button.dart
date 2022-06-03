import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';

class MainButton extends StatelessWidget {
  final Widget newPage;

  const MainButton({
    Key? key,
    required this.newPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => newPage),
        ),
        style: AppTheme.mainButtonStyle(context),
        child: Text(
          "Vacinar",
          style: AppTheme.titleTextStyle.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
