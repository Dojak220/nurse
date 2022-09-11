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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NURSE',
      theme: AppTheme.themeData,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      initialRoute: "/",
      routes: {
        "/": (context) => Home(title: "Nurse"),
        "/vaccinations": (context) => VaccinationEntry(title: "Nurse"),
        "/vaccinations/new": (context) => VaccinationEntry(title: "Nurse"),
        "/persons": (context) => EmptyPage("person"),
        "/persons/new": (context) => EmptyPage("person/new"),
        "/patients": (context) => EmptyPage("patient"),
        "/patients/new": (context) => EmptyPage("patient/new"),
        "/establishments": (context) => EmptyPage("establishment"),
        "/establishments/new": (context) =>
            AddEstablishmentForm(AddEstablishmentFormController()),
        "/appliers": (context) => EmptyPage("applier"),
        "/appliers/new": (context) =>
            AddApplierForm(AddApplierFormController()),
        "/vaccines": (context) => EmptyPage("vaccine"),
        "/vaccines/new": (context) => EmptyPage("vaccine/new"),
        "/vaccineBatches": (context) => EmptyPage("vaccineBatch"),
        "/vaccineBatches/new": (context) => EmptyPage("vaccineBatch/new"),
        "/localities": (context) => EmptyPage("locality"),
        "/localities/new": (context) =>
            AddLocalityForm(AddLocalityFormController()),
        "/campaigns": (context) => EmptyPage("campaign"),
        "/campaigns/new": (context) =>
            AddCampaignForm(AddCampaignFormController()),
        "/priorityGroups": (context) => EmptyPage("priorityGroup"),
        "/priorityGroups/new": (context) => EmptyPage("priorityGroup/new"),
        "/priorityCategories": (context) => EmptyPage("priorityCategory"),
        "/priorityCategories/new": (context) =>
            EmptyPage("priorityCategory/new"),
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
    return Container(
      child: Center(child: Text(title)),
    );
  }
}
