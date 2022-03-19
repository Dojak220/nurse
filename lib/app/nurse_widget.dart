import 'package:flutter/material.dart';
import 'package:nurse/app/modules/Home/home.dart';
import 'package:nurse/app/theme/app_theme.dart';

class Nurse extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NURSE',
      theme: AppTheme.themeData,
      home: Home(title: 'NURSE'),
    );
  }
}
