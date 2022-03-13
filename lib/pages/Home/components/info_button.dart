import 'package:flutter/material.dart';
import 'package:nurse/theme/app_theme.dart';
import 'package:nurse/theme/colors.dart';

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
      height: 50,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(4.0),
          bottomLeft: const Radius.circular(4.0),
        ),
        color: CustomColors.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Center(
              child: Row(
                children: [
                  Text(
                    '$info',
                    style: AppTheme.infoButtonNumberStyle,
                  ),
                  Text(' '),
                  Text('$text'),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.play_arrow),
            color: CustomColors.azulSodalina,
          )
        ],
      ),
    );
  }
}
