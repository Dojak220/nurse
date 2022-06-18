import 'package:flutter/material.dart';
import 'package:nurse/app/modules/ApplierEntry/applier_form.dart';
import 'package:nurse/app/modules/CampaignEntry/campaign_form.dart';
import 'package:nurse/app/modules/PatientEntry/patient_form.dart';
import 'package:nurse/app/modules/VaccinationEntry/application_form.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_save_step_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_step_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry_controller.dart';
import 'package:nurse/app/modules/VaccineEntry/vaccine_form.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VaccinationEntryController>(context);

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
                      PatientForm(controller.patientFormController),
                      ApplierForm(controller.applierFormController),
                      VaccineForm(controller.vaccineFormController),
                      ApplicationForm(controller.applicationFormController),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    StepFormButton(
                      active: controller.formIndex != 0,
                      onPressed: () => controller
                          .onFormIndexChanged(controller.formIndex - 1),
                      text: "Voltar",
                    ),
                    SizedBox(width: 20),
                    controller.formIndex == controller.formsCount
                        ? SaveFormButton()
                        : StepFormButton(
                            active:
                                controller.formIndex < controller.formsCount,
                            onPressed: () => controller.onNextButtonPressed(
                              controller,
                              controller.getFormController(
                                  controller, controller.formIndex),
                            ),
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
