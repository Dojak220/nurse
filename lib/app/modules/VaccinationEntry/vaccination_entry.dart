import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_save_step_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form_step_button.dart';
import 'package:nurse/app/nurse_widget.dart';

class VaccinationEntry extends StatefulWidget {
  const VaccinationEntry({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<VaccinationEntry> createState() => _VaccinationEntryState();
}

class _VaccinationEntryState extends State<VaccinationEntry> {
  static const int _formsCount = 5;
  int _formIndex = 0;

  final _patientForm = FocusNode();
  final _applierForm = FocusNode();
  final _vaccineForm = FocusNode();
  final _campaignForm = FocusNode();
  final _applicationForm = FocusNode();

  @override
  void dispose() {
    _patientForm.dispose();
    _applierForm.dispose();
    _vaccineForm.dispose();
    _campaignForm.dispose();
    _applicationForm.dispose();
    super.dispose();
  }

  void _onFormIndexChanged(int index) {
    setState(() {
      _formIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom * 0.1;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, bottom),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: IndexedStack(
                  index: _formIndex,
                  children: [
                    EmptyPage("Patient"),
                    EmptyPage("Applier"),
                    EmptyPage("Vaccine"),
                    EmptyPage("Campaign"),
                    VaccinationForm(),
                    EmptyPage("Dados para revisão")
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
                          onPressed: () => _onFormIndexChanged(_formIndex + 1),
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
