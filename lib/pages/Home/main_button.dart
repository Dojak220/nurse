import 'package:flutter/material.dart';
import 'package:nurse/theme/app_theme.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
      child: ElevatedButton(
        onPressed: () {},
        style: AppTheme.mainButtonStyle(context),
        child: Text(
          "Vacinar",
          style: AppTheme.titleTextStyle,
        ),
      ),
    );
  }
}
