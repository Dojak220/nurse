import 'package:flutter/material.dart';
import 'package:nurse/app/components/registration_failed_alert_dialog.dart';
import 'package:nurse/app/modules/EntityEntry/add_applier_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field%20.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class AddApplierForm extends StatefulWidget {
  final AddApplierFormController controller;

  AddApplierForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<AddApplierForm> createState() => _AddApplierFormState();
}

class _AddApplierFormState extends State<AddApplierForm> {
  List<Locality> _localities = List<Locality>.empty(growable: true);
  List<Establishment> _establishments =
      List<Establishment>.empty(growable: true);

  @override
  void initState() {
    _getLocalities();
    _getEstablishments();
    super.initState();
  }

  Future<void> _getLocalities() async {
    _localities = await widget.controller.getLocalities();
    setState(() {});
  }

  Future<void> _getEstablishments() async {
    _establishments = await widget.controller.getEstablishments();
    setState(() {});
  }

  void tryToSave(AddApplierFormController controller) async {
    final wasSaved = await controller.saveInfo();

    if (wasSaved) {
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return RegistrationFailedAlertDialog(entityName: "aplicante");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args["title"],
          style: TextStyle(
            fontSize: 32,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _ApplierFormFields(
                controller: widget.controller,
                establishments: _establishments,
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
                  child: Text("Salvar"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplierFormFields extends StatefulWidget {
  final AddApplierFormController controller;
  final List<Locality> localities;
  final List<Establishment> establishments;

  const _ApplierFormFields({
    Key? key,
    required this.controller,
    required this.localities,
    required this.establishments,
  }) : super(key: key);

  @override
  State<_ApplierFormFields> createState() => _ApplierFormFieldsState();
}

class _ApplierFormFieldsState extends State<_ApplierFormFields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListView(
          children: [
            CustomDropdownButtonFormField(
              icon: Icon(Icons.local_hospital),
              label: FormLabels.establishmentCNES,
              items: widget.establishments,
              onChanged: (Establishment? value) => setState(
                  () => widget.controller.selectedEstablishment = value),
              onSaved: (Establishment? value) =>
                  widget.controller.selectedEstablishment = value,
            ),
            Divider(color: Colors.black),
            CustomTextFormField(
              icon: Icon(Icons.abc),
              label: FormLabels.applierName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.Name,
              onSaved: (value) => {},
            ),
            Divider(color: Colors.black),
            CustomTextFormField(
              icon: Icon(Icons.badge),
              label: FormLabels.applierCns,
              textEditingController: widget.controller.cns,
              validatorType: ValidatorType.CNS,
              onSaved: (value) => {},
            ),
            Divider(color: Colors.black),
            CustomTextFormField(
              icon: Icon(Icons.badge),
              label: FormLabels.applierCpf,
              textEditingController: widget.controller.cpf,
              validatorType: ValidatorType.CPF,
              onSaved: (value) => {},
            ),
            Divider(color: Colors.black),
            CustomTextFormField(
              icon: Icon(Icons.calendar_month),
              label: FormLabels.birthDate,
              textEditingController: widget.controller.birthDate,
              validatorType: ValidatorType.BirthDate,
              onTap: () async => widget.controller.selectDate(context),
              readOnly: true,
              onSaved: (value) => {},
            ),
            Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: Icon(Icons.pin),
              label: FormLabels.establishmentLocalityName,
              items: widget.localities,
              value: widget.controller.selectedLocality,
              onChanged: (Locality? value) =>
                  setState(() => widget.controller.selectedLocality = value),
              onSaved: (Locality? value) =>
                  setState(() => widget.controller.selectedLocality = value),
            ),
            Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: widget.controller.selectedSex == Sex.NONE
                  ? Icon(Icons.question_mark)
                  : widget.controller.selectedSex == Sex.FEMALE
                      ? Icon(Icons.female)
                      : Icon(Icons.male),
              label: FormLabels.sex,
              items: Sex.values,
              value: widget.controller.selectedSex,
              isEnum: true,
              onChanged: (Sex? value) => setState(() {
                widget.controller.selectedSex = value!;
              }),
            ),
            Divider(color: Colors.black),
            CustomTextFormField(
              icon: Icon(Icons.abc),
              label: FormLabels.motherName,
              textEditingController: widget.controller.motherName,
              validatorType: ValidatorType.OptionalName,
              onSaved: (value) => {},
            ),
            Divider(color: Colors.black),
            CustomTextFormField(
              icon: Icon(Icons.abc),
              label: FormLabels.fatherName,
              textEditingController: widget.controller.fatherName,
              validatorType: ValidatorType.OptionalName,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}
