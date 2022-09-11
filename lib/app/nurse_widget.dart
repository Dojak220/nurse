import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nurse/app/modules/EntityEntry/add_applier_form.dart';
import 'package:nurse/app/modules/EntityEntry/add_applier_form_controller.dart';
import 'package:nurse/app/modules/EntityEntry/add_campaign_form.dart';
import 'package:nurse/app/modules/EntityEntry/add_campaign_form_controller.dart';
import 'package:nurse/app/modules/EntityEntry/add_establishment_form.dart';
import 'package:nurse/app/modules/EntityEntry/add_establishment_form_controller.dart';
import 'package:nurse/app/modules/EntityEntry/add_locality_form.dart';
import 'package:nurse/app/modules/EntityEntry/add_locality_form_controller.dart';
import 'package:nurse/app/modules/Home/home_page.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry.dart';
import 'package:nurse/app/theme/app_theme.dart';

class Nurse extends StatelessWidget {
  const Nurse({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NURSE',
      theme: AppTheme.themeData,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      initialRoute: "/",
      routes: {
        "/": (context) => const Home(title: "Nurse"),
        "/vaccinations": (context) => const VaccinationEntry(title: "Nurse"),
        "/vaccinations/new": (context) =>
            const VaccinationEntry(title: "Nurse"),
        "/persons": (context) => const EmptyPage("person"),
        "/persons/new": (context) => const EmptyPage("person/new"),
        "/patients": (context) => const EmptyPage("patient"),
        "/patients/new": (context) => const EmptyPage("patient/new"),
        "/establishments": (context) => const EmptyPage("establishment"),
        "/establishments/new": (context) =>
            AddEstablishmentForm(AddEstablishmentFormController()),
        "/appliers": (context) => const EmptyPage("applier"),
        "/appliers/new": (context) =>
            AddApplierForm(AddApplierFormController()),
        "/vaccines": (context) => const EmptyPage("vaccine"),
        "/vaccines/new": (context) => const EmptyPage("vaccine/new"),
        "/vaccineBatches": (context) => const EmptyPage("vaccineBatch"),
        "/vaccineBatches/new": (context) => const EmptyPage("vaccineBatch/new"),
        "/localities": (context) => const EmptyPage("locality"),
        "/localities/new": (context) =>
            AddLocalityForm(AddLocalityFormController()),
        "/campaigns": (context) => const EmptyPage("campaign"),
        "/campaigns/new": (context) =>
            AddCampaignForm(AddCampaignFormController()),
        "/priorityGroups": (context) => const EmptyPage("priorityGroup"),
        "/priorityGroups/new": (context) =>
            const EmptyPage("priorityGroup/new"),
        "/priorityCategories": (context) => const EmptyPage("priorityCategory"),
        "/priorityCategories/new": (context) =>
            const EmptyPage("priorityCategory/new"),
      },
    );
  }
}

class EmptyPage extends StatelessWidget {
  final String title;

  const EmptyPage(
    this.title, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}
