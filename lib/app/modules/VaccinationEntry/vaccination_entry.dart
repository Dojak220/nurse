import "package:flutter/material.dart";
import "package:nurse/app/modules/VaccinationEntry/Forms/ApplicationEntry/application_form.dart";
import "package:nurse/app/modules/VaccinationEntry/Forms/ApplierEntry/applier_form.dart";
import "package:nurse/app/modules/VaccinationEntry/Forms/CampaignEntry/campaign_form.dart";
import "package:nurse/app/modules/VaccinationEntry/Forms/PatientEntry/patient_form.dart";
import "package:nurse/app/modules/VaccinationEntry/Forms/VaccineEntry/vaccine_form.dart";
import "package:nurse/app/modules/VaccinationEntry/components/dialog_confirm_button.dart";
import "package:nurse/app/modules/VaccinationEntry/components/form_save_step_button.dart";
import "package:nurse/app/modules/VaccinationEntry/components/form_step_button.dart";
import "package:nurse/app/modules/VaccinationEntry/vaccination_entry_controller.dart";

class VaccinationEntry extends StatefulWidget {
  final VaccinationEntryController controller;

  const VaccinationEntry(
    this.controller, {
    Key? key,
  }) : super(key: key);

  @override
  State<VaccinationEntry> createState() => _VaccinationEntryState();
}

class _VaccinationEntryState extends State<VaccinationEntry> {
  /// TODO: Verificar se o build context é necessário, dado que o contexto pode
  ///  ser acessado globalmente.
  Future<void> tryToSave(
    BuildContext context,
    VaccinationEntryController controller,
  ) async {
    final isValid = controller.submitIfFormValid(
      controller.getCurrentFormController(),
    );

    if (!isValid) return;

    final wasSaved = await controller.saveVaccination(context);

    if (wasSaved) {
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      showDialog<void>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.warning_rounded, size: 120.0),
                Text("Falha ao cadastrar!", textAlign: TextAlign.center),
              ],
            ),
            content: const Text(
              "Cadastro já existia no banco de dados!",
              textAlign: TextAlign.center,
            ),
            actions: const [DialogConfirmButton(text: "Ok")],
            actionsAlignment: MainAxisAlignment.spaceAround,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final VaccinationEntryController controller = widget.controller;

    return WillPopScope(
      onWillPop: () async => controller.cleanAllForms(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Nurse")),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: controller.formIndex,
                  children: [
                    CampaignForm(controller.campaignFormController),
                    ApplierForm(controller.applierFormController),
                    VaccineForm(controller.vaccineFormController),
                    PatientForm(controller.patientFormController),
                    ApplicationForm(controller.applicationFormController),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: Row(
                  children: [
                    StepFormButton(
                      active: controller.formIndex != 0,
                      onPressed: () =>
                          setState(() => controller.previousForm()),
                      text: "Voltar",
                    ),
                    const SizedBox(width: 20),
                    if (controller.isLastForm)
                      SaveStepFormButton(
                        () => tryToSave(context, controller),
                      )
                    else
                      StepFormButton(
                        active: !controller.isLastForm,
                        onPressed: () => setState(() => controller.nextForm()),
                        text: "Avançar",
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
