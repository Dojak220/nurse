import 'package:flutter/material.dart';
import 'package:nurse/app/components/registration_failed_alert_dialog.dart';
import 'package:nurse/app/modules/EntityEntry/vaccination/add_vaccine_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/utils/validator.dart';

class AddVaccineForm extends StatefulWidget {
  final AddVaccineFormController controller;

  const AddVaccineForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<AddVaccineForm> createState() => _AddVaccineFormState();
}

class _AddVaccineFormState extends State<AddVaccineForm> {
  void tryToSave(AddVaccineFormController controller) async {
    final wasSaved = await controller.saveInfo();

    if (wasSaved) {
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      showDialog<void>(
        context: context,
        builder: (_) {
          return const RegistrationFailedAlertDialog(entityName: "vacina");
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
              child: _VaccineFormFields(controller: widget.controller),
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
}

class _VaccineFormFields extends StatefulWidget {
  final AddVaccineFormController controller;

  const _VaccineFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<_VaccineFormFields> createState() => _VaccineFormFieldsState();
}

class _VaccineFormFieldsState extends State<_VaccineFormFields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListView(
          children: [
            CustomTextFormField(
              icon: const Icon(Icons.local_pharmacy),
              label: FormLabels.vaccineLaboratory,
              textEditingController: widget.controller.laboratory,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc),
              label: FormLabels.vaccineName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.numbers),
              label: FormLabels.vaccineSipniCode,
              textEditingController: widget.controller.sipniCode,
              validatorType: ValidatorType.numericalString,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}
