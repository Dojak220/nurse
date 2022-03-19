import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/app/theme/colors.dart';

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
        borderRadius: new BorderRadius.circular(4.0),
        color: CustomColors.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0),
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
                Text(vaccine),
                Text(group),
                Text(pregnant),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
