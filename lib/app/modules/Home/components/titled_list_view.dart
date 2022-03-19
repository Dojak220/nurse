import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/app/theme/colors.dart';

class TitledListView extends StatelessWidget {
  const TitledListView({
    Key? key,
    required this.title,
    required this.listView,
    this.color = CustomColors.azulSodalina,
    this.padding = const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
  }) : super(key: key);

  final String title;
  final ListView listView;
  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: AppTheme.titleTextStyle,
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.35,
            ),
            color: color,
            padding: padding,
            child: listView,
          ),
        ],
      ),
    );
  }
}
