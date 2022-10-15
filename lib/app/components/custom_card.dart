import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/app/theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    this.upperTitle,
    required this.title,
    this.leftInfo,
    this.centerInfo,
    this.rightInfo,
  }) : super(key: key);

  final String? upperTitle;
  final String title;
  final String? leftInfo;
  final String? centerInfo;
  final String? rightInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.cinzaClaro,
        boxShadow: const [
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
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 10.0, 0, 0),
            child: Visibility(
              visible: upperTitle != null,
              child: Text(
                upperTitle!,
                style: AppTheme.tileHeaderStyle,
              ),
            ),
          ),
          ListTile(
            dense: true,
            title: Text(title, style: AppTheme.tileTitleStyle),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Visibility(
                    visible: leftInfo != null,
                    child: Text(
                      leftInfo!,
                      textAlign: TextAlign.start,
                      style: AppTheme.tileHeaderStyle
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: centerInfo != null,
                    child: Text(
                      centerInfo!,
                      textAlign: TextAlign.center,
                      style: AppTheme.tileHeaderStyle
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: rightInfo != null,
                    child: Text(
                      rightInfo!,
                      textAlign: TextAlign.end,
                      style: AppTheme.tileHeaderStyle
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
