import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/app/theme/app_colors.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({
    Key? key,
    required this.cns,
    required this.name,
    required this.vaccine,
    required this.group,
    required this.pregnant,
  }) : super(key: key);

  final String cns;
  final String name;
  final String vaccine;
  final String group;
  final String pregnant;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        color: AppColors.cinzaClaro,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 10.0, 0, 0),
            child: Text(
              cns,
              style: AppTheme.tileHeaderStyle,
            ),
          ),
          ListTile(
            dense: true,
            title: Text(name, style: AppTheme.tileTitleStyle),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    vaccine,
                    textAlign: TextAlign.start,
                    style: AppTheme.tileHeaderStyle
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: Text(
                    group,
                    textAlign: TextAlign.center,
                    style: AppTheme.tileHeaderStyle
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: pregnant != "Nenhum",
                    child: Text(
                      pregnant,
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
