import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_theme.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({
    Key? key,
    required this.info,
    required this.text,
  }) : super(key: key);

  final int info;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 73,
      width: 94,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10),
        color: Color(0xFFF5F5F5),
        boxShadow: [
          BoxShadow(
            color: Color(0x29000000),
            blurRadius: 6.0,
            spreadRadius: 0,
            blurStyle: BlurStyle.normal,
            offset: Offset(
              0.0,
              3.0,
            ),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            top: 10,
            child: Text(
              "$info",
              style: AppTheme.infoButtonNumberStyle,
            ),
          ),
          Positioned(
            bottom: 6,
            child: Text(
              "$text",
              style: AppTheme.infoButtonTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
