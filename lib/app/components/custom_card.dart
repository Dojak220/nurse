import 'package:flutter/material.dart';
import 'package:nurse/app/components/edit_button.dart';
import 'package:nurse/app/components/info_text.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/app/theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    this.upperTitle,
    required this.title,
    this.startInfo,
    this.centerInfo,
    this.endInfo,
    required this.onEditPressed,
  }) : super(key: key);

  final String? upperTitle;
  final String title;
  final String? startInfo;
  final String? centerInfo;
  final String? endInfo;

  final void Function() onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
          margin: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UpperTitle(upperTitle: upperTitle),
              ListTile(
                dense: true,
                title: Text(title, style: AppTheme.tileTitleStyle),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (startInfo != null)
                      InfoText(info: startInfo, textAlign: TextAlign.start),
                    if (centerInfo != null)
                      InfoText(info: centerInfo, textAlign: TextAlign.center),
                    if (endInfo != null)
                      InfoText(info: endInfo, textAlign: TextAlign.end),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: Align(
            alignment: const Alignment(0.975, 0),
            child: EditButton(onEditPressed: onEditPressed),
          ),
        ),
      ],
    );
  }
}

class UpperTitle extends StatelessWidget {
  const UpperTitle({
    Key? key,
    required this.upperTitle,
  }) : super(key: key);

  final String? upperTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 0, 0),
      child: Visibility(
        visible: upperTitle != null,
        child: Text(
          upperTitle!,
          style: AppTheme.tileHeaderStyle,
        ),
      ),
    );
  }
}
