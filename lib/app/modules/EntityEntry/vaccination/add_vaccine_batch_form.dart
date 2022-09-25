import 'package:flutter/material.dart';
import 'package:nurse/app/components/registration_failed_alert_dialog.dart';
import 'package:nurse/app/modules/EntityEntry/vaccination/add_vaccine_batch_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class AddVaccineBatchForm extends StatefulWidget {
  final AddVaccineBatchFormController controller;

  const AddVaccineBatchForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<AddVaccineBatchForm> createState() => _AddVaccineBatchFormState();
}

class _AddVaccineBatchFormState extends State<AddVaccineBatchForm> {
  List<Vaccine> _vaccines = List<Vaccine>.empty(growable: true);

  @override
  void initState() {
    _getLocalities();
    super.initState();
  }

  Future<void> _getLocalities() async {
    _vaccines = await widget.controller.getLocalities();
    setState(() {});
  }

  void tryToSave(AddVaccineBatchFormController controller) async {
    final wasSaved = await controller.saveInfo();

    if (wasSaved) {
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      showDialog<void>(
        context: context,
        builder: (_) {
          return const RegistrationFailedAlertDialog(
            entityName: "lote de vacina",
          );
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
              child: _VaccineBatchFormFields(
                controller: widget.controller,
                vaccines: _vaccines,
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
}

class _VaccineBatchFormFields extends StatefulWidget {
  final AddVaccineBatchFormController controller;
  final List<Vaccine> vaccines;

  const _VaccineBatchFormFields({
    Key? key,
    required this.controller,
    required this.vaccines,
  }) : super(key: key);

  @override
  State<_VaccineBatchFormFields> createState() =>
      _VaccineBatchFormFieldsState();
}

class _VaccineBatchFormFieldsState extends State<_VaccineBatchFormFields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListView(
          children: [
            CustomDropdownButtonFormField(
              icon: const Icon(Icons.vaccines),
              label: FormLabels.vaccineName,
              items: widget.vaccines,
              onChanged: (Vaccine? value) =>
                  setState(() => widget.controller.selectedVaccine = value),
              onSaved: (Vaccine? value) =>
                  widget.controller.selectedVaccine = value,
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.numbers),
              label: FormLabels.vaccineBatchNumber,
              textEditingController: widget.controller.number,
              validatorType: ValidatorType.numericalString,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.batch_prediction),
              label: FormLabels.vaccineBatchQuantity,
              textEditingController: widget.controller.quantity,
              validatorType: ValidatorType.numericalString,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}
