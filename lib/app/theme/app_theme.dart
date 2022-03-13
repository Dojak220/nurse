// Verde esmeralda: #009473
// Verde flash: #78C753
// Branco: #FFF
// Preto saúde: #282B34
// Cinza: #DDD
// Cinza gárgula: #686767
// Vermelho fita: #B92636
// Azul sodalina: #253668

import 'package:flutter/material.dart';
import 'package:nurse/app/theme/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData themeData = ThemeData(
    fontFamily: 'OpenSans',
    appBarTheme: _appBarTheme,
    textTheme: _textTheme,
  );

  static AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: CustomColors.cinzaGargula,
    titleTextStyle: _appBarTextStyle,
    toolbarTextStyle: _appBarTextStyle,
    centerTitle: true,
    toolbarHeight: 60.0,
  );

  static TextStyle _appBarTextStyle = const TextStyle(
    fontSize: 45.0,
    fontFamily: 'Righteous',
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: CustomColors.verdeEsmeralda,
  );

  static TextStyle titleTextStyle = const TextStyle(
    fontSize: 28.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    color: CustomColors.pretoSaude,
  );

  static TextStyle defaultTextStyle = const TextStyle(
    fontSize: 18.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: CustomColors.pretoSaude,
  );

  static TextStyle infoButtonNumberStyle = const TextStyle(
    fontSize: 25.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    color: CustomColors.verdeEsmeralda,
  );

  static TextStyle tileHeaderStyle = const TextStyle(
    fontSize: 13.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: CustomColors.cinzaGargula,
  );

  static TextStyle tileTitleStyle = const TextStyle(
    fontSize: 18.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    color: CustomColors.verdeEsmeralda,
  );

  static ButtonStyle mainButtonStyle(BuildContext context) =>
      ElevatedButton.styleFrom(
        primary: CustomColors.cinza, // background
        onPrimary: CustomColors.pretoSaude,
        fixedSize: Size(
          MediaQuery.of(context).size.width,
          50,
        ),
      );

  static TextTheme _textTheme = TextTheme(
    bodyText2: defaultTextStyle,
  );
}
