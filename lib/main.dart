import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nurse/app/modules/ApplierEntry/applier_form_controller.dart';
import 'package:nurse/app/modules/Home/home_controller.dart';
import 'package:nurse/app/modules/PatientEntry/patient_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry_controller.dart';
import 'package:nurse/app/modules/VaccineEntry/vaccine_form_controller.dart';
import 'package:nurse/app/nurse_widget.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:provider/provider.dart';

void main() async {
  loadEnviromentVariables().whenComplete(() {
    startDatabase().whenComplete(() {
      runApp(MultiProvider(
        providers: [
          Provider<HomeController>(
            create: (_) => HomeController(),
          ),
          Provider<VaccinationEntryController>(
            create: (_) => VaccinationEntryController(),
          ),
          Provider<PatientFormController>(
            create: (_) => PatientFormController(),
          ),
          Provider<ApplierFormController>(
            create: (_) => ApplierFormController(),
          ),
          Provider<VaccineFormController>(
            create: (_) => VaccineFormController(),
          ),
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
