import "package:flutter/material.dart";
import "package:nurse/app/theme/app_theme.dart";

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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF5F5F5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29000000),
            blurRadius: 6.0,
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
              text,
              style: AppTheme.infoButtonTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
