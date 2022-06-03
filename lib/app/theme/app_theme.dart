// Verde esmeralda: #009473
// Verde flash: #78C753
// Branco: #FFF
// Preto saúde: #282B34
// Cinza: #DDD
// Cinza gárgula: #686767
// Vermelho fita: #B92636
// Azul sodalina: #253668

import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData themeData = ThemeData(
    fontFamily: 'OpenSans',
    appBarTheme: _appBarTheme,
    textTheme: _textTheme,
  );

  static AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: AppColors.verdeClaro,
    shadowColor: AppColors.transparent,
    titleTextStyle: _appBarTextStyle,
    toolbarTextStyle: _appBarTextStyle,
    centerTitle: true,
    toolbarHeight: 60.0,
  );

  static TextStyle _appBarTextStyle = const TextStyle(
    fontSize: 45.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    color: AppColors.verdeEscuro,
  );

  static TextStyle titleTextStyle = const TextStyle(
    fontSize: 17.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    color: AppColors.cinzaEscuro,
  );

  static TextStyle defaultTextStyle = const TextStyle(
    fontSize: 18.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: AppColors.black,
  );

  static TextStyle infoButtonNumberStyle = const TextStyle(
    fontSize: 41.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    color: AppColors.verdeEscuro,
  );

  static TextStyle infoButtonTextStyle = const TextStyle(
    fontSize: 14.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    height: 1.0,
    color: AppColors.cinzaEscuro,
  );

  static TextStyle tileHeaderStyle = const TextStyle(
    fontSize: 10.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: AppColors.cinzaEscuro,
  );

  static TextStyle tileTitleStyle = const TextStyle(
    fontSize: 18.0,
    fontFamily: 'Roboto',
    height: 0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    color: AppColors.verdeEscuro,
  );

  static ButtonStyle dialogButtonStyle = ElevatedButton.styleFrom(
    textStyle: infoButtonTextStyle,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    primary: AppColors.verdeEscuro,
    fixedSize: Size(120, 25),
    side: BorderSide(color: AppColors.verdeEscuro, width: 2),
  );

  static ButtonStyle mainButtonStyle([BuildContext? context]) =>
      ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        primary: AppColors.verdeEscuro,
        fixedSize: context != null
            ? Size(MediaQuery.of(context).size.width, 50)
            : null,
      );

  static TextTheme _textTheme = TextTheme(
    bodyText2: defaultTextStyle,
  );
}
