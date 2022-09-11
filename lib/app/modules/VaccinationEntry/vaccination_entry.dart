import 'package:flutter/material.dart';
import 'package:nurse/app/modules/Forms/ApplicationEntry/application_form.dart';
import 'package:nurse/app/modules/Forms/ApplierEntry/applier_form.dart';
import 'package:nurse/app/modules/Forms/CampaignEntry/campaign_form.dart';
import 'package:nurse/app/modules/Forms/PatientEntry/patient_form.dart';
import 'package:nurse/app/modules/Forms/VaccineEntry/vaccine_form.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/dialog_confirm_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_save_step_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_step_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry_controller.dart';

class VaccinationEntry extends StatefulWidget {
  final String title;

  const VaccinationEntry({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<VaccinationEntry> createState() => _VaccinationEntryState();
}

class _VaccinationEntryState extends State<VaccinationEntry> {
  final controller = VaccinationEntryController();

  /// TODO: Verificar se o build context é necessário, dado que o contexto pode
  ///  ser acessado globalmente.
  void tryToSave(
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
              children: const <Widget>[
                Icon(Icons.warning, size: 120.0),
                Text('Falha ao cadastrar!', textAlign: TextAlign.center),
              ],
            ),
            content: const Text(
              'Cadastro já existia no banco de dados!',
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
    return WillPopScope(
      onWillPop: () async => controller.cleanAllForms(),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                Row(
                  children: [
                    StepFormButton(
                      active: controller.formIndex != 0,
                      onPressed: () =>
                          setState(() => controller.previousForm()),
                      text: "Voltar",
                    ),
                    const SizedBox(width: 20),
                    controller.isLastForm
                        ? SaveStepFormButton(
                            () => tryToSave(context, controller),
                          )
                        : StepFormButton(
                            active: !controller.isLastForm,
                            onPressed: () =>
                                setState(() => controller.nextForm()),
                            text: "Avançar",
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
