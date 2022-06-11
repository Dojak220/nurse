import 'package:flutter/material.dart';
import 'package:nurse/app/modules/ApplierEntry/applier_form.dart';
import 'package:nurse/app/modules/ApplierEntry/applier_form_controller.dart';
import 'package:nurse/app/modules/PatientEntry/patient_form_controller.dart';
import 'package:nurse/app/modules/PatientEntry/patient_form.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_save_step_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_step_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/vaccination_form.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry_controller.dart';
import 'package:nurse/app/modules/VaccineEntry/vaccine_form.dart';
import 'package:nurse/app/modules/VaccineEntry/vaccine_form_controller.dart';
import 'package:nurse/app/nurse_widget.dart';
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
      _onFormIndexChanged(_formIndex + 1);
    }
  }

  FormController getFormController(BuildContext context, int formIndex) {
    switch (formIndex) {
      case 0:
        return Provider.of<PatientFormController>(context, listen: false);
      case 1:
        return Provider.of<ApplierFormController>(context, listen: false);
      case 2:
        return Provider.of<VaccineFormController>(context, listen: false);
      default:
        throw Exception('Invalid form index');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VaccinationEntryController>(context);
    final patientFormController = Provider.of<PatientFormController>(context);
    final applierFormController = Provider.of<ApplierFormController>(context);
    final vaccineFormController = Provider.of<VaccineFormController>(context);

    return Scaffold(
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
                    PatientForm(controller: patientFormController),
                    ApplierForm(controller: applierFormController),
                    VaccineForm(controller: vaccineFormController),
                    EmptyPage("Campaign"),
                    VaccinationForm(),
                    EmptyPage("Dados para revisão"),
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
    );
  }
}
