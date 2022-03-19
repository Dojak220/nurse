import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nurse/app/pages/Home/home.dart';
import 'package:nurse/app/theme/app_theme.dart';

void main() async {
  loadEnviromentVariables().then((_) {
    runApp(Nurse());
  });
}

Future<void> loadEnviromentVariables() async {
  await dotenv.load();
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
