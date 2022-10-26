import 'package:flutter/material.dart';
import 'package:nurse/app/modules/EntityEntry/vaccination/add_vaccine_batch_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class VaccineBatchFormFields extends StatefulWidget {
  final AddVaccineBatchFormController controller;

  const VaccineBatchFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<VaccineBatchFormFields> createState() => VaccineBatchFormFieldsState();
}

class VaccineBatchFormFieldsState extends State<VaccineBatchFormFields> {
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
              items: _vaccines,
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