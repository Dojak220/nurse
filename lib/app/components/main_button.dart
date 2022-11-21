import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isEnable = true,
  }) : super(key: key);

  final String text;
  final void Function()? onPressed;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnable ? onPressed : () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        foregroundColor: isEnable ? AppColors.verdeClaro : AppColors.cinzaMedio,
        backgroundColor:
            isEnable ? AppColors.verdeEscuro : AppColors.cinzaMedio2,
        fixedSize: Size(MediaQuery.of(context).size.width * 0.90, 50),
        shadowColor: AppColors.black,
      ),
      child: Text(
        text,
        style: AppTheme.titleTextStyle.copyWith(color: AppColors.white),
      ),
    );
  }
}
