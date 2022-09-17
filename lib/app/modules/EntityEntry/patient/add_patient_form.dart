import 'package:flutter/material.dart';
import 'package:nurse/app/components/registration_failed_alert_dialog.dart';
import 'package:nurse/app/modules/EntityEntry/patient/add_patient_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class AddPatientForm extends StatefulWidget {
  final AddPatientFormController controller;

  const AddPatientForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<AddPatientForm> createState() => _AddPatientFormState();
}

class _AddPatientFormState extends State<AddPatientForm> {
  List<Locality> _localities = List<Locality>.empty(growable: true);
  List<PriorityCategory> _categories =
      List<PriorityCategory>.empty(growable: true);

  @override
  void initState() {
    _getLocalities();
    _getPriorityCategories();
    super.initState();
  }

  Future<void> _getLocalities() async {
    _localities = await widget.controller.getLocalities();
    setState(() {});
  }

  Future<void> _getPriorityCategories() async {
    _categories = await widget.controller.getPriorityCategories();
    setState(() {});
  }

  void tryToSave(AddPatientFormController controller) async {
    final wasSaved = await controller.saveInfo();

    if (wasSaved) {
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      showDialog<void>(
        context: context,
        builder: (_) {
          return const RegistrationFailedAlertDialog(entityName: "paciente");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args["title"]!,
          style: const TextStyle(
            fontSize: 32,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _PatientFormFields(
                controller: widget.controller,
                categories: _categories,
                localities: _localities,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(5),
                width: double.infinity,
                child: ElevatedButton(
                  style: AppTheme.stepButtonStyle,
                  onPressed: () => tryToSave(widget.controller),
                  child: const Text("Salvar"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}

class _PatientFormFields extends StatefulWidget {
  final AddPatientFormController controller;
  final List<Locality> localities;
  final List<PriorityCategory> categories;

  const _PatientFormFields({
    Key? key,
    required this.controller,
    required this.localities,
    required this.categories,
  }) : super(key: key);

  @override
  State<_PatientFormFields> createState() => _PatientFormFieldsState();
}

class _PatientFormFieldsState extends State<_PatientFormFields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListView(
          children: [
            CustomTextFormField(
              icon: const Icon(Icons.abc),
              label: FormLabels.patientName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.badge),
              label: FormLabels.patientCns,
              textEditingController: widget.controller.cns,
              validatorType: ValidatorType.cns,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.badge),
              label: FormLabels.patientCpf,
              textEditingController: widget.controller.cpf,
              validatorType: ValidatorType.cpf,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.calendar_month),
              label: FormLabels.birthDate,
              textEditingController: widget.controller.birthDate,
              validatorType: ValidatorType.birthDate,
              onTap: () async => widget.controller.selectDate(context),
              readOnly: true,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: const Icon(Icons.category),
              label: FormLabels.category,
              items: widget.categories,
              onChanged: (PriorityCategory? value) => setState(
                  () => widget.controller.selectedPriorityCategory = value),
              onSaved: (PriorityCategory? value) =>
                  widget.controller.selectedPriorityCategory = value,
            ),
            const Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: widget.controller.selectedSex == Sex.none
                  ? const Icon(Icons.question_mark)
                  : widget.controller.selectedSex == Sex.female
                      ? const Icon(Icons.female)
                      : const Icon(Icons.male),
              label: FormLabels.sex,
              items: Sex.values,
              value: widget.controller.selectedSex,
              isEnum: true,
              onChanged: (Sex? value) => setState(() {
                widget.controller.selectedSex = value!;
              }),
            ),
            const Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: widget.controller.selectedMaternalCondition ==
                      MaternalCondition.nenhum
                  ? const Icon(Icons.question_mark)
                  : widget.controller.selectedMaternalCondition ==
                          MaternalCondition.gestante
                      ? const Icon(Icons.pregnant_woman)
                      : const Icon(Icons.baby_changing_station),
              label: FormLabels.maternalCondition,
              items: widget.controller.selectedSex == Sex.male
                  ? [MaternalCondition.nenhum]
                  : MaternalCondition.values,
              value: widget.controller.selectedSex == Sex.male
                  ? MaternalCondition.nenhum
                  : widget.controller.selectedMaternalCondition,
              isEnum: true,
              onChanged: (MaternalCondition? value) => setState(() {
                widget.controller.selectedMaternalCondition = value!;
              }),
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc),
              label: FormLabels.motherName,
              textEditingController: widget.controller.motherName,
              validatorType: ValidatorType.optionalName,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc),
              label: FormLabels.fatherName,
              textEditingController: widget.controller.fatherName,
              validatorType: ValidatorType.optionalName,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}
