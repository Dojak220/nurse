import 'package:flutter/material.dart';
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
        "/establishments/new": (context) => EmptyPage("establishment/new"),
        "/appliers": (context) => EmptyPage("applier"),
        "/appliers/new": (context) => EmptyPage("applier/new"),
        "/vaccines": (context) => EmptyPage("vaccine"),
        "/vaccines/new": (context) => EmptyPage("vaccine/new"),
        "/vaccineBatches": (context) => EmptyPage("vaccineBatch"),
        "/vaccineBatches/new": (context) => EmptyPage("vaccineBatch/new"),
        "/localities": (context) => EmptyPage("locality"),
        "/localities/new": (context) => EmptyPage("locality/new"),
        "/campaigns": (context) => EmptyPage("campaign"),
        "/campaigns/new": (context) => EmptyPage("campaign/new"),
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
