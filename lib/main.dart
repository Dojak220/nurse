import 'package:flutter/material.dart';
import 'package:nurse/pages/Home/home.dart';
import 'package:nurse/theme/app_theme.dart';

void main() {
  runApp(Nurse());
}

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
