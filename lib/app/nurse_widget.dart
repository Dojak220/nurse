import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:nurse/app/main_screen.dart";
import "package:nurse/app/modules/EntityList/add_entities_menu_page.dart";
import "package:nurse/app/modules/EntityList/add_form.dart";
import "package:nurse/app/modules/EntityList/infra/campaign/add_campaign_form_controller.dart";
import "package:nurse/app/modules/EntityList/infra/campaign/add_campaign_form_fields.dart";
import "package:nurse/app/modules/EntityList/infra/campaign/campaign_page_controller.dart";
import "package:nurse/app/modules/EntityList/infra/campaign/campaigns_page.dart";
import "package:nurse/app/modules/EntityList/infra/establishment/add_establishment_form_controller.dart";
import "package:nurse/app/modules/EntityList/infra/establishment/add_establishment_form_fields.dart";
import "package:nurse/app/modules/EntityList/infra/establishment/establishment_page.dart";
import "package:nurse/app/modules/EntityList/infra/establishment/establishment_page_controller.dart";
import "package:nurse/app/modules/EntityList/infra/locality/add_locality_form_controller.dart";
import "package:nurse/app/modules/EntityList/infra/locality/add_locality_form_fields.dart";
import "package:nurse/app/modules/EntityList/infra/locality/locality_page.dart";
import "package:nurse/app/modules/EntityList/infra/locality/locality_page_controller.dart";
import "package:nurse/app/modules/EntityList/patient/patient/add_patient_form_controller.dart";
import "package:nurse/app/modules/EntityList/patient/patient/add_patient_form_fields.dart";
import "package:nurse/app/modules/EntityList/patient/patient/patient_page.dart";
import "package:nurse/app/modules/EntityList/patient/patient/patient_page_controller.dart";
import "package:nurse/app/modules/EntityList/patient/priorityCategory/add_priority_category_form_controller.dart";
import "package:nurse/app/modules/EntityList/patient/priorityCategory/add_priority_category_form_fields.dart";
import "package:nurse/app/modules/EntityList/patient/priorityCategory/priority_category_page.dart";
import "package:nurse/app/modules/EntityList/patient/priorityCategory/priority_category_page_controller.dart";
import "package:nurse/app/modules/EntityList/patient/priorityGroup/add_priority_group_form_controller.dart";
import "package:nurse/app/modules/EntityList/patient/priorityGroup/add_priority_group_form_fields.dart";
import "package:nurse/app/modules/EntityList/patient/priorityGroup/priority_group_page.dart";
import "package:nurse/app/modules/EntityList/patient/priorityGroup/priority_group_page_controller.dart";
import "package:nurse/app/modules/EntityList/vaccination/applier/add_applier_form_controller.dart";
import "package:nurse/app/modules/EntityList/vaccination/applier/add_applier_form_fields.dart";
import "package:nurse/app/modules/EntityList/vaccination/applier/applier_page.dart";
import "package:nurse/app/modules/EntityList/vaccination/applier/applier_page_controller.dart";
import "package:nurse/app/modules/EntityList/vaccination/vaccine/add_vaccine_form_controller.dart";
import "package:nurse/app/modules/EntityList/vaccination/vaccine/add_vaccine_form_fields.dart";
import "package:nurse/app/modules/EntityList/vaccination/vaccine/vaccine_page.dart";
import "package:nurse/app/modules/EntityList/vaccination/vaccine/vaccine_page_controller.dart";
import "package:nurse/app/modules/EntityList/vaccination/vaccineBatch/add_vaccine_batch_form_controller.dart";
import "package:nurse/app/modules/EntityList/vaccination/vaccineBatch/add_vaccine_batch_form_fields.dart";
import "package:nurse/app/modules/EntityList/vaccination/vaccineBatch/vaccine_batch_page.dart";
import "package:nurse/app/modules/EntityList/vaccination/vaccineBatch/vaccine_batch_page_controller.dart";
import "package:nurse/app/modules/Export/export_data_page.dart";
import "package:nurse/app/modules/Home/home_page.dart";
import "package:nurse/app/modules/VaccinationEntry/vaccination_entry.dart";
import "package:nurse/app/modules/VaccinationEntry/vaccination_entry_controller.dart";
import "package:nurse/app/theme/app_theme.dart";
import "package:nurse/shared/models/infra/campaign_model.dart";
import "package:nurse/shared/models/infra/establishment_model.dart";
import "package:nurse/shared/models/infra/locality_model.dart";
import "package:nurse/shared/models/patient/patient_model.dart";
import "package:nurse/shared/models/patient/priority_category_model.dart";
import "package:nurse/shared/models/patient/priority_group_model.dart";
import "package:nurse/shared/models/vaccination/application_model.dart";
import "package:nurse/shared/models/vaccination/applier_model.dart";
import "package:nurse/shared/models/vaccination/vaccine_batch_model.dart";
import "package:nurse/shared/models/vaccination/vaccine_model.dart";

class Nurse extends StatelessWidget {
  const Nurse({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NURSE",
      theme: AppTheme.themeData,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale("pt", "BR")],
      initialRoute: "/",
      routes: {
        "/": (context) => const MainScreen(),
        "/home": (context) => const Home(),

        // Entity List
        "/entities": (context) => const AddEntitiesMenuPage(),

        // INFRA ROUTES
        "/campaigns": (context) => Campaigns(CampaignsPageController()),
        "/campaigns/new": (context) => newCampaignFormPage(context),
        "/establishments": (context) =>
            Establishments(EstablishmentsPageController()),
        "/establishments/new": (context) => newEstablishmentFormPage(context),
        "/localities": (context) => Localities(LocalitiesPageController()),
        "/localities/new": (context) => newLocalityFormPage(context),

        // PATIENT ROUTES
        "/patients": (context) => Patients(PatientsPageController()),
        "/patients/new": (context) => newPatientFormPage(context),
        "/priorityCategories": (context) =>
            PriorityCategories(PriorityCategoriesPageController()),
        "/priorityCategories/new": (context) =>
            newPriorityCategoryFormPage(context),
        "/priorityGroups": (context) =>
            PriorityGroups(PriorityGroupsPageController()),
        "/priorityGroups/new": (context) => newPriorityGroupFormPage(context),

        // VACCINATION ROUTES
        "/vaccinations/new": (context) => newVaccinationFormPage(context),
        "/appliers": (context) => Appliers(AppliersPageController()),
        "/appliers/new": (context) => newApplierFormPage(context),
        "/vaccineBatches": (context) =>
            VaccineBatches(VaccineBatchesPageController()),
        "/vaccineBatches/new": (context) => newVaccineBatchFormPage(context),
        "/vaccines": (context) => Vaccines(VaccinesPageController()),
        "/vaccines/new": (context) => newVaccineFormPage(context),

        // SHARE ROUTE
        "/share": (context) => const ExportVaccinationDataPage(),
      },
    );
  }

  VaccinationEntry newVaccinationFormPage(BuildContext context) {
    final applicationToEdit = getEntityToEdit<Application>(context);

    final controller = VaccinationEntryController(applicationToEdit);

    return VaccinationEntry(controller);
  }

  AddForm newPriorityCategoryFormPage(BuildContext context) {
    final priorityCategoryToEdit = getEntityToEdit<PriorityCategory>(context);

    final controller =
        AddPriorityCategoryFormController(priorityCategoryToEdit);

    return AddForm(
      controller,
      title: "Categoria Prioritária",
      formFields: PriorityCategoryFormFields(controller: controller),
      isEditing: priorityCategoryToEdit != null,
    );
  }

  AddForm newPriorityGroupFormPage(BuildContext context) {
    final priorityGroupToEdit = getEntityToEdit<PriorityGroup>(context);

    final controller = AddPriorityGroupFormController(priorityGroupToEdit);

    return AddForm(
      controller,
      title: "Grupos Prioritário",
      formFields: PriorityGroupFormFields(controller: controller),
      isEditing: priorityGroupToEdit != null,
    );
  }

  AddForm newCampaignFormPage(BuildContext context) {
    final campaignToEdit = getEntityToEdit<Campaign>(context);

    final controller = AddCampaignFormController(campaignToEdit);

    return AddForm(
      controller,
      title: "Campanhas",
      formFields: CampaignFormFields(controller: controller),
      isEditing: campaignToEdit != null,
    );
  }

  AddForm newLocalityFormPage(BuildContext context) {
    final localityToEdit = getEntityToEdit<Locality>(context);

    final controller = AddLocalityFormController(localityToEdit);

    return AddForm(
      controller,
      title: "Localidades",
      formFields: LocalityFormFields(controller: controller),
      isEditing: localityToEdit != null,
    );
  }

  AddForm newVaccineBatchFormPage(BuildContext context) {
    final vaccineBatchToEdit = getEntityToEdit<VaccineBatch>(context);

    final controller = AddVaccineBatchFormController(vaccineBatchToEdit);

    return AddForm(
      controller,
      title: "Lotes de Vacina",
      formFields: VaccineBatchFormFields(controller: controller),
      isEditing: vaccineBatchToEdit != null,
    );
  }

  AddForm newVaccineFormPage(BuildContext context) {
    final vaccineToEdit = getEntityToEdit<Vaccine>(context);

    final controller = AddVaccineFormController(vaccineToEdit);

    return AddForm(
      controller,
      title: "Vacinas",
      formFields: VaccineFormFields(controller: controller),
      isEditing: vaccineToEdit != null,
    );
  }

  AddForm newApplierFormPage(BuildContext context) {
    final applierToEdit = getEntityToEdit<Applier>(context);

    final controller = AddApplierFormController(applierToEdit);

    return AddForm(
      controller,
      title: "Aplicantes",
      formFields: ApplierFormFields(controller: controller),
      isEditing: applierToEdit != null,
    );
  }

  AddForm newEstablishmentFormPage(BuildContext context) {
    final establishmentToEdit = getEntityToEdit<Establishment>(context);

    final controller = AddEstablishmentFormController(establishmentToEdit);

    return AddForm(
      controller,
      title: "Estabelecimentos",
      formFields: EstablishmentFormFields(controller: controller),
      isEditing: establishmentToEdit != null,
    );
  }

  AddForm newPatientFormPage(BuildContext context) {
    final patientToEdit = getEntityToEdit<Patient>(context);

    final controller = AddPatientFormController(patientToEdit);

    return AddForm(
      controller,
      title: "Pacientes",
      formFields: PatientFormFields(controller: controller),
      isEditing: patientToEdit != null,
    );
  }

  T? getEntityToEdit<T>(BuildContext context) =>
      ModalRoute.of(context)!.settings.arguments as T?;
}
