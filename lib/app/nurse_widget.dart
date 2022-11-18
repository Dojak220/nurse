import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nurse/app/modules/EntityList/add_form.dart';
import 'package:nurse/app/modules/EntityList/infra/locality/add_locality_form_fields.dart';
import 'package:nurse/app/modules/EntityList/patient/patient/add_patient_form_fields.dart';
import 'package:nurse/app/modules/EntityList/patient/patient/add_patient_form_controller.dart';
import 'package:nurse/app/modules/EntityList/patient/priorityCategory/add_priority_category_form_fields.dart';
import 'package:nurse/app/modules/EntityList/patient/priorityCategory/add_priority_category_form_controller.dart';
import 'package:nurse/app/modules/EntityList/patient/priorityGroup/add_priority_group_form_fields.dart';
import 'package:nurse/app/modules/EntityList/patient/priorityGroup/add_priority_group_form_controller.dart';
import 'package:nurse/app/modules/EntityList/vaccination/applier/add_applier_form_fields.dart';
import 'package:nurse/app/modules/EntityList/vaccination/applier/add_applier_form_controller.dart';
import 'package:nurse/app/modules/EntityList/vaccination/vaccineBatch/add_vaccine_batch_form_fields.dart';
import 'package:nurse/app/modules/EntityList/vaccination/vaccineBatch/add_vaccine_batch_form_controller.dart';
import 'package:nurse/app/modules/EntityList/vaccination/vaccine/add_vaccine_form_fields.dart';
import 'package:nurse/app/modules/EntityList/vaccination/vaccine/add_vaccine_form_controller.dart';
import 'package:nurse/app/modules/EntityList/infra/locality/add_locality_form_controller.dart';
import 'package:nurse/app/modules/EntityList/infra/campaign/add_campaign_form_controller.dart';
import 'package:nurse/app/modules/EntityList/infra/campaign/add_campaign_form_fields.dart';
import 'package:nurse/app/modules/EntityList/infra/campaign/campaigns_page.dart';
import 'package:nurse/app/modules/EntityList/infra/establishment/add_establishment_form_controller.dart';
import 'package:nurse/app/modules/EntityList/infra/establishment/add_establishment_form_fields.dart';
import 'package:nurse/app/modules/EntityList/infra/establishment/establishment_page.dart';
import 'package:nurse/app/modules/EntityList/infra/locality/locality_page.dart';
import 'package:nurse/app/modules/EntityList/patient/patient/patient_page.dart';
import 'package:nurse/app/modules/EntityList/patient/priorityCategory/priority_category_page.dart';
import 'package:nurse/app/modules/EntityList/patient/priorityGroup/priority_group_page.dart';
import 'package:nurse/app/modules/EntityList/vaccination/applier/applier_page.dart';
import 'package:nurse/app/modules/EntityList/vaccination/vaccineBatch/vaccine_batch_page.dart';
import 'package:nurse/app/modules/EntityList/vaccination/vaccine/vaccine_page.dart';
import 'package:nurse/app/modules/Home/home_page.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry_controller.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';

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
        "/patients": (context) => const Patients(),
        "/patients/new": (context) {
          final currentPatient =
              ModalRoute.of(context)!.settings.arguments as Patient?;

          final controller = AddPatientFormController(currentPatient);

          return AddForm(
            controller,
            title: "Pacientes",
            formFields: PatientFormFields(controller: controller),
            isEditing: currentPatient != null,
          );
        },
        "/establishments": (context) => const Establishments(),
        "/establishments/new": (context) {
          final currentEstablishment =
              ModalRoute.of(context)!.settings.arguments as Establishment?;

          final controller =
              AddEstablishmentFormController(currentEstablishment);

          return AddForm(
            controller,
            title: "Estabelecimentos",
            formFields: EstablishmentFormFields(controller: controller),
            isEditing: currentEstablishment != null,
          );
        },
        "/appliers": (context) => const Appliers(),
        "/appliers/new": (context) {
          final currentApplier =
              ModalRoute.of(context)!.settings.arguments as Applier?;

          final controller = AddApplierFormController(currentApplier);

          return AddForm(
            controller,
            title: "Aplicantes",
            formFields: ApplierFormFields(controller: controller),
            isEditing: currentApplier != null,
          );
        },
        "/vaccines": (context) => const Vaccines(),
        "/vaccines/new": (context) {
          final currentVaccine =
              ModalRoute.of(context)!.settings.arguments as Vaccine?;

          final controller = AddVaccineFormController(currentVaccine);

          return AddForm(
            controller,
            title: "Vacinas",
            formFields: VaccineFormFields(controller: controller),
            isEditing: currentVaccine != null,
          );
        },
        "/vaccineBatches": (context) => const VaccineBatches(),
        "/vaccineBatches/new": (context) {
          final currentVaccineBatch =
              ModalRoute.of(context)!.settings.arguments as VaccineBatch?;

          final controller = AddVaccineBatchFormController(currentVaccineBatch);

          return AddForm(
            controller,
            title: "Lotes de Vacina",
            formFields: VaccineBatchFormFields(controller: controller),
            isEditing: currentVaccineBatch != null,
          );
        },
        "/localities": (context) => const Localities(),
        "/localities/new": (context) {
          final currentLocality =
              ModalRoute.of(context)!.settings.arguments as Locality?;

          final controller = AddLocalityFormController(currentLocality);

          return AddForm(
            controller,
            title: "Localidades",
            formFields: LocalityFormFields(controller: controller),
            isEditing: currentLocality != null,
          );
        },
        "/campaigns": (context) => const Campaigns(),
        "/campaigns/new": (context) {
          final currentCampaign =
              ModalRoute.of(context)!.settings.arguments as Campaign?;

          final controller = AddCampaignFormController(currentCampaign);

          return AddForm(
            controller,
            title: "Campanhas",
            formFields: CampaignFormFields(controller: controller),
            isEditing: currentCampaign != null,
          );
        },
        "/priorityGroups": (context) => const PriorityGroups(),
        "/priorityGroups/new": (context) {
          final currentPriorityGroup =
              ModalRoute.of(context)!.settings.arguments as PriorityGroup?;
          final controller =
              AddPriorityGroupFormController(currentPriorityGroup);

          return AddForm(
            controller,
            title: "Grupos Prioritário",
            formFields: PriorityGroupFormFields(controller: controller),
            isEditing: currentPriorityGroup != null,
          );
        },
        "/priorityCategories": (context) => const PriorityCategories(),
        "/priorityCategories/new": (context) {
          final currentPriorityCategory =
              ModalRoute.of(context)!.settings.arguments as PriorityCategory?;

          final controller =
              AddPriorityCategoryFormController(currentPriorityCategory);

          return AddForm(
            controller,
            title: "Categoria Prioritária",
            formFields: PriorityCategoryFormFields(controller: controller),
            isEditing: currentPriorityCategory != null,
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
