import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nurse/app/modules/Home/home_controller.dart';
import 'package:nurse/app/nurse_widget.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:provider/provider.dart';

void main() async {
  loadEnviromentVariables().whenComplete(() {
    startDatabase().whenComplete(() {
      runApp(MultiProvider(
        providers: [
          Provider<HomeController>(create: (_) => HomeController()),
        ],
        child: Nurse(),
      ));
    });
  });
}

Future<void> loadEnviromentVariables() async {
  await dotenv.load();
}

Future<void> startDatabase() async {
  await DatabaseManager().tryToInit();
}
