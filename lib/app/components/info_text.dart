import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_theme.dart';

class InfoText extends StatelessWidget {
  const InfoText({
    Key? key,
    required this.info,
    required this.textAlign,
  }) : super(key: key);

  final String? info;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Visibility(
        visible: info != null,
        child: Text(
          info ?? "",
          textAlign: textAlign,
          style: AppTheme.tileHeaderStyle.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
