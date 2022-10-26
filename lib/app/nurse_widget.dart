import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nurse/app/modules/EntityEntry/add_form.dart';
import 'package:nurse/app/modules/EntityEntry/infra/add_campaign_form_fields.dart';
import 'package:nurse/app/modules/EntityEntry/infra/add_locality_form_fields.dart';
import 'package:nurse/app/modules/EntityEntry/patient/add_patient_form_fields.dart';
import 'package:nurse/app/modules/EntityEntry/patient/add_patient_form_controller.dart';
import 'package:nurse/app/modules/EntityEntry/patient/add_priority_category_form_fields.dart';
import 'package:nurse/app/modules/EntityEntry/patient/add_priority_category_form_controller.dart';
import 'package:nurse/app/modules/EntityEntry/patient/add_priority_group_form_fields.dart';
import 'package:nurse/app/modules/EntityEntry/patient/add_priority_group_form_controller.dart';
import 'package:nurse/app/modules/EntityEntry/vaccination/add_applier_form_fields.dart';
import 'package:nurse/app/modules/EntityEntry/vaccination/add_applier_form_controller.dart';
import 'package:nurse/app/modules/EntityEntry/vaccination/add_vaccine_batch_form_fields.dart';
import 'package:nurse/app/modules/EntityEntry/vaccination/add_vaccine_batch_form_controller.dart';
import 'package:nurse/app/modules/EntityEntry/vaccination/add_vaccine_form_fields.dart';
import 'package:nurse/app/modules/EntityEntry/vaccination/add_vaccine_form_controller.dart';
import 'package:nurse/app/modules/EntityEntry/infra/add_campaign_form_controller.dart';
import 'package:nurse/app/modules/EntityEntry/infra/add_establishment_form_fields.dart';
import 'package:nurse/app/modules/EntityEntry/infra/add_establishment_form_controller.dart';
import 'package:nurse/app/modules/EntityEntry/infra/add_locality_form_controller.dart';
import 'package:nurse/app/modules/EntityList/infra/campaigns_page.dart';
import 'package:nurse/app/modules/Home/home_page.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry_controller.dart';
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
        "/": (context) => const Home(title: "Imunização"),
        "/vaccinations": (context) => const EmptyPage("vaccination"),
        "/vaccinations/new": (context) =>
            VaccinationEntry(VaccinationEntryController()),
        "/patients": (context) => const EmptyPage("patient"),
        "/patients/new": (context) {
          final controller = AddPatientFormController();

          return AddForm(
            controller,
            title: "Paciente",
            formFields: PatientFormFields(controller: controller),
          );
        },
        "/establishments": (context) => const EmptyPage("establishment"),
        "/establishments/new": (context) {
          final controller = AddEstablishmentFormController();

          return AddForm(
            controller,
            title: "Estabelecimento",
            formFields: EstablishmentFormFields(controller: controller),
          );
        },
        "/appliers": (context) => const EmptyPage("applier"),
        "/appliers/new": (context) {
          final controller = AddApplierFormController();

          return AddForm(
            controller,
            title: "Aplicante",
            formFields: ApplierFormFields(controller: controller),
          );
        },
        "/vaccines": (context) => const EmptyPage("vaccine"),
        "/vaccines/new": (context) {
          final controller = AddVaccineFormController();

          return AddForm(
            controller,
            title: "Vacina",
            formFields: VaccineFormFields(controller: controller),
          );
        },
        "/vaccineBatches": (context) => const EmptyPage("vaccineBatch"),
        "/vaccineBatches/new": (context) {
          final controller = AddVaccineBatchFormController();

          return AddForm(
            controller,
            title: "Lote de Vacina",
            formFields: VaccineBatchFormFields(controller: controller),
          );
        },
        "/localities": (context) => const EmptyPage("locality"),
        "/localities/new": (context) {
          final controller = AddLocalityFormController();

          return AddForm(
            controller,
            title: "Localidade",
            formFields: LocalityFormFields(controller: controller),
          );
        },
        "/campaigns": (context) => const Campaigns(),
        "/campaigns/new": (context) {
          final controller = AddCampaignFormController();

          return AddForm(
            controller,
            title: "Campanha",
            formFields: CampaignFormFields(controller: controller),
          );
        },
        "/priorityGroups": (context) => const EmptyPage("priorityGroup"),
        "/priorityGroups/new": (context) {
          final controller = AddPriorityGroupFormController();

          return AddForm(
            controller,
            title: "Grupo Prioritário",
            formFields: PriorityGroupFormFields(controller: controller),
          );
        },
        "/priorityCategories": (context) => const EmptyPage("priorityCategory"),
        "/priorityCategories/new": (context) {
          final controller = AddPriorityCategoryFormController();

          return AddForm(
            controller,
            title: "Categoria Prioritária",
            formFields: PriorityCategoryFormFields(controller: controller),
          );
        },
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
