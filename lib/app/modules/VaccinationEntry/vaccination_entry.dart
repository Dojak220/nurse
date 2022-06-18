import 'package:flutter/material.dart';
import 'package:nurse/app/modules/ApplierEntry/applier_form.dart';
import 'package:nurse/app/modules/ApplierEntry/applier_form_controller.dart';
import 'package:nurse/app/modules/CampaignEntry/campaign_form.dart';
import 'package:nurse/app/modules/CampaignEntry/campaign_form_controller.dart';
import 'package:nurse/app/modules/PatientEntry/patient_form_controller.dart';
import 'package:nurse/app/modules/PatientEntry/patient_form.dart';
import 'package:nurse/app/modules/VaccinationEntry/application_form.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_save_step_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_step_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/application_form_controller.dart';
import 'package:nurse/app/modules/VaccineEntry/vaccine_form.dart';
import 'package:nurse/app/modules/VaccineEntry/vaccine_form_controller.dart';
import 'package:nurse/app/utils/form_controller.dart';
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
  static const _formsCount = 5;
  int _formIndex = 0;

  void _onFormIndexChanged(int index) {
    setState(() {
      _formIndex = index;
    });
  }

  void _onNextButtonPressed(
    VaccinationEntryController controller,
    FormController formController,
  ) {
    final allFieldsValid = formController.formKey.currentState!.validate();

    if (allFieldsValid) {
      formController.submitForm();
      if (_formIndex < _formsCount - 1) {
        _onFormIndexChanged(_formIndex + 1);
      } else {
        controller.saveVaccination();
      }
    }
  }

  FormController getFormController(BuildContext context, int formIndex) {
    switch (formIndex) {
      case 0:
        return Provider.of<CampaignFormController>(context, listen: false);
      case 1:
        return Provider.of<PatientFormController>(context, listen: false);
      case 2:
        return Provider.of<ApplierFormController>(context, listen: false);
      case 3:
        return Provider.of<VaccineFormController>(context, listen: false);
      case 4:
        return Provider.of<ApplicationFormController>(context, listen: false);
      default:
        throw Exception('Unknown form index');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VaccinationEntryController>(context);
    final campaignFormController = Provider.of<CampaignFormController>(context);
    final patientFormController = Provider.of<PatientFormController>(context);
    final applierFormController = Provider.of<ApplierFormController>(context);
    final vaccineFormController = Provider.of<VaccineFormController>(context);
    final applicationFormController =
        Provider.of<ApplicationFormController>(context);

    return WillPopScope(
      onWillPop: () async {
        campaignFormController.cleanAllInfo();
        patientFormController.cleanAllInfo();
        applierFormController.cleanAllInfo();
        vaccineFormController.cleanAllInfo();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 25.0),
            child: Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: _formIndex,
                    children: [
                      CampaignForm(controller: campaignFormController),
                      PatientForm(controller: patientFormController),
                      ApplierForm(controller: applierFormController),
                      VaccineForm(controller: vaccineFormController),
                      ApplicationForm(controller: applicationFormController),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    StepFormButton(
                      active: _formIndex != 0,
                      onPressed: () => _onFormIndexChanged(_formIndex - 1),
                      text: "Voltar",
                    ),
                    SizedBox(width: 20),
                    _formIndex == _formsCount
                        ? SaveFormButton()
                        : StepFormButton(
                            active: _formIndex < _formsCount,
                            onPressed: () => _onNextButtonPressed(
                              controller,
                              getFormController(context, _formIndex),
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
