import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nurse/app/modules/EntityList/infra/campaign/campaign_page_controller.dart';
import 'package:nurse/app/modules/EntityList/infra/establishment/establishment_page_controller.dart';
import 'package:nurse/app/modules/EntityList/infra/locality/locality_page_controller.dart';
import 'package:nurse/app/modules/EntityList/patient/patient/patient_page_controller.dart';
import 'package:nurse/app/modules/EntityList/patient/priorityCategory/priority_category_page_controller.dart';
import 'package:nurse/app/modules/EntityList/patient/priorityGroup/priority_group_page_controller.dart';
import 'package:nurse/app/modules/EntityList/vaccination/applier/applier_page_controller.dart';
import 'package:nurse/app/modules/EntityList/vaccination/vaccine/vaccine_page_controller.dart';
import 'package:nurse/app/modules/EntityList/vaccination/vaccineBatch/vaccine_batch_page_controller.dart';
import 'package:nurse/app/modules/Home/home_controller.dart';
import 'package:nurse/app/nurse_widget.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:provider/provider.dart';

void main() async {
  loadEnvironmentVariables().whenComplete(() {
    startDatabase().whenComplete(() {
      runApp(MultiProvider(
        providers: [
          Provider<HomeController>(create: (_) => HomeController()),
          Provider<CampaignsPageController>(
            create: (_) => CampaignsPageController(),
          ),
          Provider<LocalitiesPageController>(
            create: (_) => LocalitiesPageController(),
          ),
          Provider<EstablishmentsPageController>(
            create: (_) => EstablishmentsPageController(),
          ),
          Provider<PriorityGroupsPageController>(
            create: (_) => PriorityGroupsPageController(),
          ),
          Provider<PriorityCategoriesPageController>(
            create: (_) => PriorityCategoriesPageController(),
          ),
          Provider<PatientsPageController>(
            create: (_) => PatientsPageController(),
          ),
          Provider<AppliersPageController>(
            create: (_) => AppliersPageController(),
          ),
          Provider<VaccinesPageController>(
            create: (_) => VaccinesPageController(),
          ),
          Provider<VaccineBatchesPageController>(
            create: (_) => VaccineBatchesPageController(),
          ),
        ],
        child: const Nurse(),
      ));
    });
  });
}

Future<void> loadEnvironmentVariables() async {
  await dotenv.load();
}

Future<void> startDatabase() async {
  await DatabaseManager().tryToInit();
}
