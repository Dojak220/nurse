import 'package:flutter/material.dart';
import 'package:nurse/app/modules/ApplierEntry/applier_form.dart';
import 'package:nurse/app/modules/CampaignEntry/campaign_form.dart';
import 'package:nurse/app/modules/PatientEntry/patient_form.dart';
import 'package:nurse/app/modules/VaccinationEntry/application_form.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/dialog_confirm_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_save_step_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_step_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry_controller.dart';
import 'package:nurse/app/modules/VaccineEntry/vaccine_form.dart';

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

  void tryToSave(
    BuildContext ctx,
    VaccinationEntryController controller,
  ) async {
    final isValid = controller.submitIfFormValid(
      controller.getCurrentFormController(),
    );

    if (!isValid) return;

    final wasSaved = await controller.saveVaccination(ctx);

    if (wasSaved) {
      Navigator.of(ctx).pop();
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.warning, size: 120.0),
                Text('Falha ao cadastrar!', textAlign: TextAlign.center),
              ],
            ),
            content: Text(
              'Cadastro já existia no banco de dados!',
              textAlign: TextAlign.center,
            ),
            actions: [DialogConfirmButton(text: "Ok")],
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
            padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 25.0),
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
                SizedBox(height: 20),
                Row(
                  children: [
                    StepFormButton(
                      active: controller.formIndex != 0,
                      onPressed: () =>
                          setState(() => controller.previousForm()),
                      text: "Voltar",
                    ),
                    SizedBox(width: 20),
                    controller.isLastForm
                        ? SaveFormButton(
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
